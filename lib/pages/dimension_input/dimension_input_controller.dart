import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/models/measurement_subtype.dart';
import 'package:ai_camera/models/dimension_annotation.dart';
import 'package:ai_camera/services/storage_service.dart';
import 'package:ai_camera/routes/app_pages.dart';

/// S-005(폭/간격) / S-008(홀 깊이) 수치 입력.
class DimensionInputController extends GetxController {
  static DimensionInputController get I => Get.find();

  late Map<String, dynamic> partial;
  late SurveyType surveyType;
  MeasurementSubtype? subtype;
  late String photoPath;

  final startValueCtrl = TextEditingController();
  final endValueCtrl = TextEditingController();
  final visibleValueCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  final measuredValue = 0.0.obs;
  final isValid = false.obs;
  final endError = false.obs; // 끝값 ≤ 시작값
  final isSaving = false.obs;

  bool get isHole => subtype == MeasurementSubtype.holeDepth;

  @override
  void onInit() {
    super.onInit();
    partial = (Get.arguments as Map<String, dynamic>?) ?? {};
    surveyType = partial['surveyType'] ?? SurveyType.dimension;
    subtype = partial['subtype'] as MeasurementSubtype?;
    photoPath = partial['photoPath'] ?? '';

    startValueCtrl.addListener(recompute);
    endValueCtrl.addListener(recompute);
    visibleValueCtrl.addListener(recompute);
  }

  @override
  void onClose() {
    startValueCtrl.dispose();
    endValueCtrl.dispose();
    visibleValueCtrl.dispose();
    noteCtrl.dispose();
    super.onClose();
  }

  void recompute() {
    if (isHole) {
      final v = double.tryParse(visibleValueCtrl.text.trim());
      measuredValue.value = v ?? 0;
      isValid.value = v != null && v > 0;
      endError.value = false;
    } else {
      final s = double.tryParse(startValueCtrl.text.trim());
      final e = double.tryParse(endValueCtrl.text.trim());
      if (s == null || e == null) {
        isValid.value = false;
        endError.value = false;
        measuredValue.value = 0;
        return;
      }
      if (e <= s) {
        isValid.value = false;
        endError.value = true;
        measuredValue.value = 0;
        return;
      }
      endError.value = false;
      measuredValue.value = e - s;
      isValid.value = true;
    }
  }

  double? _parse(TextEditingController c) => double.tryParse(c.text.trim());

  List<double>? _px(String key) {
    final v = partial[key];
    if (v == null) return null;
    return (v as List).map((e) => (e as num).toDouble()).toList();
  }

  Future<void> save() async {
    if (!isValid.value || isSaving.value) return;
    isSaving.value = true;

    final annotation = DimensionAnnotation(
      startPointPixel: _px('startPointPixel'),
      endPointPixel: _px('endPointPixel'),
      holeLipPixel: _px('holeLipPixel'),
      tapeReadingPixel: _px('tapeReadingPixel'),
      startValue: _parse(startValueCtrl),
      endValue: _parse(endValueCtrl),
      visibleReadingValue: _parse(visibleValueCtrl),
      measuredValue: measuredValue.value,
      startSurfaceType: partial['startSurfaceType'],
      endSurfaceType: partial['endSurfaceType'],
      tapeDirection: isHole ? 'vertical' : 'horizontal',
      startVisibility: partial['startVisibility'],
      contactConfirmation: partial['contactConfirm'],
      qualityFlags: null,
      imageWidth: partial['imageWidth'] ?? 0,
      imageHeight: partial['imageHeight'] ?? 0,
    );

    final record = SurveyRecord(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      surveyType: SurveyType.dimension,
      measurementSubtype: subtype,
      photoPath: photoPath,
      value: measuredValue.value,
      annotation: annotation,
      note: noteCtrl.text.trim(),
      timestamp: DateTime.now(),
    );

    await StorageService.I.addRecord(record);
    isSaving.value = false;

    // 카메라(같은 subtype 유지)로 복귀 — 연속 측정.
    Get.until((route) => route.name == AppRoutes.camera);
  }

  void retake() {
    try {
      File(photoPath).deleteSync();
    } catch (_) {}
    Get.until((route) => route.name == AppRoutes.camera);
  }
}
