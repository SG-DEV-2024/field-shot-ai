import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/services/storage_service.dart';

class DataInputController extends GetxController {
  static DataInputController get I => Get.find();

  late String photoPath;
  late SurveyType surveyType;

  final valueController = TextEditingController();
  final noteController = TextEditingController();
  final isSaving = false.obs;
  final isValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    photoPath = args?['photoPath'] ?? '';
    surveyType = args?['surveyType'] ?? SurveyType.carbonation;

    valueController.addListener(() {
      final val = double.tryParse(valueController.text.trim());
      isValid.value = val != null;
    });
  }

  @override
  void onClose() {
    valueController.dispose();
    noteController.dispose();
    super.onClose();
  }

  void openPhotoViewer() {
    Get.toNamed('/photo-viewer', arguments: {'photoPath': photoPath});
  }

  Future<void> save() async {
    if (!isValid.value || isSaving.value) return;
    isSaving.value = true;

    final record = SurveyRecord(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      surveyType: surveyType,
      photoPath: photoPath,
      value: double.parse(valueController.text.trim()),
      note: noteController.text.trim(),
      timestamp: DateTime.now(),
    );

    await StorageService.I.addRecord(record);
    isSaving.value = false;

    // 저장 후 카메라(이전 화면)로 복귀 — 연속 측정.
    // 메인으로 가려면 사용자가 카메라에서 ← 뒤로가기 사용.
    Get.back();
  }

  void retake() {
    try { File(photoPath).deleteSync(); } catch (_) {}
    Get.back();
  }
}
