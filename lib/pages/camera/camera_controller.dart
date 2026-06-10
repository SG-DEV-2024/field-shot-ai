import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/models/measurement_subtype.dart';
import 'package:ai_camera/routes/app_pages.dart';
import 'package:ai_camera/widgets/guide_box_painter.dart';
import 'package:ai_camera/global.dart';

enum FlashMode2 { auto, on, off }

class CameraController2 extends GetxController {
  static CameraController2 get I => Get.find();

  late CameraController cameraController;
  final isInitialized = false.obs;
  final zoomLevel = 2.0.obs;
  final flashMode = FlashMode2.auto.obs;
  final lastPhotoPath = ''.obs;
  final isCapturing = false.obs;
  final tiltAngle = 0.0.obs; // radians (SMA 보정)
  final isLevel = true.obs; // 수평 여부
  final isLocked = false.obs; // 기울기 심하면 셔터 잠금 (탄산화 전용)

  static const int _smaWindow = 5;
  static const double _deadZone = 1.5 * math.pi / 180;
  static const double _levelThreshold = 15.0 * math.pi / 180;
  static const double _lockThreshold = 16.0 * math.pi / 180;
  final _angleBuf = <double>[];

  StreamSubscription? _accelSub;
  late SurveyType surveyType;
  MeasurementSubtype? subtype;
  late GuideBoxMode guideMode;

  /// 폭/간격(S-003) 가이드박스 좌·우 핸들 위치 (preview 영역 너비 대비 0..1 비율).
  final startHandleFrac = 0.12.obs;
  final endHandleFrac = 0.88.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    surveyType = args?['surveyType'] ?? SurveyType.carbonation;
    subtype = args?['subtype'] as MeasurementSubtype?;
    guideMode = resolveGuideBoxMode(surveyType, subtype);
    _initCamera();
    _initTiltSensor();
  }

  bool get isDimension => surveyType == SurveyType.dimension;
  bool get showHandles => guideMode == GuideBoxMode.rectHorizontalWide;

  String get hintText {
    if (surveyType == SurveyType.carbonation) {
      return '가이드 박스 안에 숫자가 꽉 차게 맞춰주세요';
    }
    return subtype?.cameraHint ?? '대상이 가이드 안에 들어오게 촬영하세요';
  }

  Future<void> _initCamera() async {
    if (cameras.isEmpty) return;
    final rearCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras[0],
    );
    cameraController = CameraController(
      rearCamera,
      ResolutionPreset.veryHigh, // 1080p — 줄자 숫자 판독 정확도 향상
      enableAudio: false,
    );
    await cameraController.initialize();
    await cameraController.setFlashMode(FlashMode.auto);
    await _applyZoom(zoomLevel.value);
    isInitialized.value = true;
  }

  void _initTiltSensor() {
    // 규격조사 카메라는 자세 잠금 미적용 (천장·구조물 등 다양한 각도 촬영).
    if (isDimension) {
      isLevel.value = true;
      isLocked.value = false;
      return;
    }
    _accelSub = accelerometerEventStream().listen((event) {
      final norm = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (norm < 0.1) return;
      final raw = math.asin((event.x / norm).clamp(-1.0, 1.0));
      _angleBuf.add(raw);
      if (_angleBuf.length > _smaWindow) _angleBuf.removeAt(0);
      final avg = _angleBuf.reduce((a, b) => a + b) / _angleBuf.length;
      final smoothed = avg.abs() < _deadZone ? 0.0 : avg;
      tiltAngle.value = smoothed;
      final absAngle = smoothed.abs();
      isLevel.value = absAngle < _levelThreshold;
      isLocked.value = absAngle >= _lockThreshold;
    });
  }

  Future<void> _applyZoom(double zoom) async {
    if (!cameraController.value.isInitialized) return;
    final minZoom = await cameraController.getMinZoomLevel();
    final maxZoom = await cameraController.getMaxZoomLevel();
    await cameraController.setZoomLevel(zoom.clamp(minZoom, maxZoom));
  }

  Future<void> setZoom(double zoom) async {
    zoomLevel.value = zoom;
    await _applyZoom(zoom);
  }

  Future<void> toggleFlash() async {
    switch (flashMode.value) {
      case FlashMode2.auto:
        flashMode.value = FlashMode2.on;
        await cameraController.setFlashMode(FlashMode.always);
        break;
      case FlashMode2.on:
        flashMode.value = FlashMode2.off;
        await cameraController.setFlashMode(FlashMode.off);
        break;
      case FlashMode2.off:
        flashMode.value = FlashMode2.auto;
        await cameraController.setFlashMode(FlashMode.auto);
        break;
    }
  }

  String get flashLabel {
    switch (flashMode.value) {
      case FlashMode2.auto:
        return 'Auto';
      case FlashMode2.on:
        return 'On';
      case FlashMode2.off:
        return 'Off';
    }
  }

  /// 핸들 드래그 (preview 비율 0..1). 핸들 원이 화면 밖으로 나가지 않도록
  /// 양 끝에 여유를 두고, 최소 간격 0.12 유지.
  void dragStartHandle(double frac) {
    startHandleFrac.value = frac.clamp(0.1, endHandleFrac.value - 0.12);
  }

  void dragEndHandle(double frac) {
    endHandleFrac.value = frac.clamp(startHandleFrac.value + 0.12, 0.9);
  }

  Future<ui.Size> _readImageSize(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final img = frame.image;
      return ui.Size(img.width.toDouble(), img.height.toDouble());
    } catch (_) {
      return const ui.Size(0, 0);
    }
  }

  Future<void> capture() async {
    if (isCapturing.value || !isInitialized.value) return;
    if (!isDimension && isLocked.value) return; // 탄산화 잠금 시 차단
    isCapturing.value = true;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/capture/photos');
      if (!await photoDir.exists()) await photoDir.create(recursive: true);

      final file = await cameraController.takePicture();
      final destPath = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(file.path).copy(destPath);
      lastPhotoPath.value = destPath;

      final size = await _readImageSize(destPath);

      if (isDimension) {
        // 폭/간격: 핸들 비율 → 원본 픽셀 사전 좌표 (세로는 중앙).
        List<double>? prefilledStart;
        List<double>? prefilledEnd;
        if (showHandles && size.width > 0) {
          final y = size.height / 2;
          prefilledStart = [startHandleFrac.value * size.width, y];
          prefilledEnd = [endHandleFrac.value * size.width, y];
        }
        Get.toNamed(AppRoutes.annotate, arguments: {
          'photoPath': destPath,
          'surveyType': surveyType,
          'subtype': subtype,
          'imageWidth': size.width.toInt(),
          'imageHeight': size.height.toInt(),
          'prefilledStart': prefilledStart,
          'prefilledEnd': prefilledEnd,
        });
      } else {
        // 탄산화: 기존대로 데이터 입력 화면.
        Get.toNamed(AppRoutes.dataInput, arguments: {
          'photoPath': destPath,
          'surveyType': surveyType,
        });
      }
    } finally {
      isCapturing.value = false;
    }
  }

  @override
  void onClose() {
    _accelSub?.cancel();
    if (isInitialized.value) cameraController.dispose();
    super.onClose();
  }
}
