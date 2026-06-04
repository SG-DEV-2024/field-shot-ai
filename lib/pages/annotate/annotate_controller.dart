import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/models/measurement_subtype.dart';
import 'package:ai_camera/routes/app_pages.dart';

/// S-004(폭/간격) / S-007(홀 깊이) 측정점 지정.
/// 좌표는 원본 이미지 픽셀 기준으로 보관, UI는 preview로 환산.
class AnnotateController extends GetxController {
  static AnnotateController get I => Get.find();

  late String photoPath;
  late SurveyType surveyType;
  MeasurementSubtype? subtype;
  late int imageWidth;
  late int imageHeight;

  // 측정점 (원본 픽셀)
  final startPoint = Rxn<Offset>(); // 폭/간격 시작
  final endPoint = Rxn<Offset>(); // 폭/간격 끝
  final holeLip = Rxn<Offset>(); // 홀 입구
  final tapeReading = Rxn<Offset>(); // 줄자 읽기 위치

  // 홀 깊이 부속 입력
  final startVisibility = Rxn<String>(); // visible | hidden_behind_lip
  final contactConfirm = Rxn<String>(); // yes | no | unknown

  bool get isHole => subtype == MeasurementSubtype.holeDepth;

  Size get originalSize => Size(imageWidth.toDouble(), imageHeight.toDouble());

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    photoPath = args?['photoPath'] ?? '';
    surveyType = args?['surveyType'] ?? SurveyType.dimension;
    subtype = args?['subtype'] as MeasurementSubtype?;
    imageWidth = args?['imageWidth'] ?? 0;
    imageHeight = args?['imageHeight'] ?? 0;

    // 이미지 크기를 못 읽었을 때 안전한 기본값
    if (imageWidth <= 0 || imageHeight <= 0) {
      imageWidth = 1440;
      imageHeight = 1080;
    }

    if (!isHole) {
      final ps = args?['prefilledStart'] as List<double>?;
      final pe = args?['prefilledEnd'] as List<double>?;
      startPoint.value = ps != null ? Offset(ps[0], ps[1]) : Offset(imageWidth * 0.3, imageHeight / 2);
      endPoint.value = pe != null ? Offset(pe[0], pe[1]) : Offset(imageWidth * 0.7, imageHeight / 2);
    }
  }

  // ---------- 좌표 변환 (BoxFit.contain) ----------
  /// 원본 픽셀 → preview 좌표
  Offset toPreview(Offset orig, Size previewSize) {
    final scale = math.min(previewSize.width / imageWidth, previewSize.height / imageHeight);
    final renderedW = imageWidth * scale;
    final renderedH = imageHeight * scale;
    final offsetX = (previewSize.width - renderedW) / 2;
    final offsetY = (previewSize.height - renderedH) / 2;
    return Offset(offsetX + orig.dx * scale, offsetY + orig.dy * scale);
  }

  /// preview 좌표 → 원본 픽셀
  Offset toOriginal(Offset preview, Size previewSize) {
    final scale = math.min(previewSize.width / imageWidth, previewSize.height / imageHeight);
    final renderedW = imageWidth * scale;
    final renderedH = imageHeight * scale;
    final offsetX = (previewSize.width - renderedW) / 2;
    final offsetY = (previewSize.height - renderedH) / 2;
    final x = ((preview.dx - offsetX) / scale).clamp(0.0, imageWidth.toDouble());
    final y = ((preview.dy - offsetY) / scale).clamp(0.0, imageHeight.toDouble());
    return Offset(x, y);
  }

  /// preview 델타 → 원본 델타 변환용 scale
  double scaleFor(Size previewSize) =>
      math.min(previewSize.width / imageWidth, previewSize.height / imageHeight);

  // ---------- 마커 이동 ----------
  void moveStart(Offset deltaOriginal) => startPoint.value = _clamp(startPoint.value! + deltaOriginal);
  void moveEnd(Offset deltaOriginal) => endPoint.value = _clamp(endPoint.value! + deltaOriginal);
  void moveHoleLip(Offset deltaOriginal) => holeLip.value = _clamp(holeLip.value! + deltaOriginal);
  void moveTape(Offset deltaOriginal) => tapeReading.value = _clamp(tapeReading.value! + deltaOriginal);

  Offset _clamp(Offset o) => Offset(
        o.dx.clamp(0.0, imageWidth.toDouble()),
        o.dy.clamp(0.0, imageHeight.toDouble()),
      );

  /// 홀 깊이: 사진 빈 곳 탭 → 다음 단계 점 배치, 둘 다 있으면 가까운 점 이동.
  void tapPlace(Offset original) {
    if (!isHole) {
      // 폭/간격: 가까운 점을 이동
      _moveNearest(original, [startPoint, endPoint]);
      return;
    }
    if (holeLip.value == null) {
      holeLip.value = original;
    } else if (tapeReading.value == null) {
      tapeReading.value = original;
    } else {
      _moveNearest(original, [holeLip, tapeReading]);
    }
  }

  void _moveNearest(Offset target, List<Rxn<Offset>> pts) {
    Rxn<Offset>? nearest;
    double best = double.infinity;
    for (final p in pts) {
      if (p.value == null) continue;
      final d = (p.value! - target).distance;
      if (d < best) {
        best = d;
        nearest = p;
      }
    }
    nearest?.value = target;
  }

  // ---------- 현재 단계 (홀 깊이 진행 표시) ----------
  int get currentStep {
    if (!isHole) return startPoint.value != null && endPoint.value != null ? 2 : 1;
    if (holeLip.value == null) return 1;
    if (tapeReading.value == null) return 2;
    if (startVisibility.value == null) return 3;
    if (contactConfirm.value == null) return 4;
    return 4;
  }

  bool get isValid {
    if (!isHole) {
      if (startPoint.value == null || endPoint.value == null) return false;
      return (startPoint.value! - endPoint.value!).distance >= 5;
    }
    return holeLip.value != null &&
        tapeReading.value != null &&
        startVisibility.value != null &&
        contactConfirm.value != null;
  }

  void next() {
    if (!isValid) return;
    final partial = <String, dynamic>{
      'photoPath': photoPath,
      'surveyType': surveyType,
      'subtype': subtype,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'startPointPixel': startPoint.value == null ? null : [startPoint.value!.dx, startPoint.value!.dy],
      'endPointPixel': endPoint.value == null ? null : [endPoint.value!.dx, endPoint.value!.dy],
      'holeLipPixel': holeLip.value == null ? null : [holeLip.value!.dx, holeLip.value!.dy],
      'tapeReadingPixel': tapeReading.value == null ? null : [tapeReading.value!.dx, tapeReading.value!.dy],
      'startVisibility': startVisibility.value,
      'contactConfirm': contactConfirm.value,
    };
    Get.toNamed(AppRoutes.dimensionInput, arguments: partial);
  }

  void retake() {
    try {
      File(photoPath).deleteSync();
    } catch (_) {}
    Get.back(); // 카메라로 복귀
  }
}
