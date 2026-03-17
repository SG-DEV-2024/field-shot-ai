import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/routes/app_pages.dart';
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
  final tiltAngle = 0.0.obs;   // radians (SMA 보정)
  final isLevel = true.obs;    // 수평 여부 (임계값: 5도)
  final isLocked = false.obs;  // 기울기 심하면 셔터 잠금 (임계값: 15도)

  static const int _smaWindow = 5;                              // 이동평균 샘플 수 (~50ms)
  static const double _deadZone = 1.5 * math.pi / 180;         // 1.5도 이하 → 0 처리
  static const double _levelThreshold = 15.0 * math.pi / 180;  // 15도
  static const double _lockThreshold = 16.0 * math.pi / 180;   // 16도
  final _angleBuf = <double>[];                                  // SMA 버퍼

  StreamSubscription? _accelSub;
  late SurveyType surveyType;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    surveyType = args?['surveyType'] ?? SurveyType.carbonation;
    _initCamera();
    _initTiltSensor();
  }

  Future<void> _initCamera() async {
    if (cameras.isEmpty) return;

    // 후면 카메라 선택
    final rearCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras[0],
    );

    cameraController = CameraController(
      rearCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await cameraController.initialize();
    await cameraController.setFlashMode(FlashMode.auto);
    await _applyZoom(zoomLevel.value);
    isInitialized.value = true;
  }

  void _initTiltSensor() {
    _accelSub = accelerometerEventStream().listen((event) {
      // 중력 벡터를 정규화해서 순수 롤(좌우 기울기)만 추출
      // 피치(앞뒤 기울임)에 영향받지 않음
      final norm = math.sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      if (norm < 0.1) return; // 값 없을 때 무시
      final raw = math.asin((event.x / norm).clamp(-1.0, 1.0));

      // SMA: 버퍼에 추가 후 윈도우 크기 유지
      _angleBuf.add(raw);
      if (_angleBuf.length > _smaWindow) _angleBuf.removeAt(0);
      final avg = _angleBuf.reduce((a, b) => a + b) / _angleBuf.length;

      // 데드존: 미세 떨림 제거
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
      case FlashMode2.auto: return '⚡ Auto';
      case FlashMode2.on:   return '⚡ On';
      case FlashMode2.off:  return '⚡ Off';
    }
  }

  Future<void> capture() async {
    if (isCapturing.value || !isInitialized.value) return;
    isCapturing.value = true;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/capture/photos');
      if (!await photoDir.exists()) await photoDir.create(recursive: true);

      final file = await cameraController.takePicture();
      final destPath = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(file.path).copy(destPath);
      lastPhotoPath.value = destPath;

      Get.toNamed(AppRoutes.dataInput, arguments: {
        'photoPath': destPath,
        'surveyType': surveyType,
      })?.then((result) {
        if (result == 'main') {
          Get.until((route) => Get.currentRoute == AppRoutes.main);
        }
      });
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
