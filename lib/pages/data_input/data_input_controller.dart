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

  Future<void> save({required bool continueCapture}) async {
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

    Get.back(result: continueCapture ? 'continue' : 'main');
  }

  void retake() {
    try { File(photoPath).deleteSync(); } catch (_) {}
    Get.back();
  }
}
