import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/services/storage_service.dart';
import 'package:ai_camera/services/upload_service.dart';

class ArchiveController extends GetxController {
  static ArchiveController get I => Get.find();

  final records = <SurveyRecord>[].obs;
  final isUploading = false.obs;
  final uploadProgress = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecords();
  }

  void _loadRecords() {
    records.value = StorageService.I.todayRecords;
  }

  int get pendingCount => records.where((r) => r.uploadStatus == UploadStatus.pending).length;

  Future<void> uploadAll() async {
    if (isUploading.value || pendingCount == 0) return;
    isUploading.value = true;
    uploadProgress.value = 0;

    final pending = records.where((r) => r.uploadStatus == UploadStatus.pending).toList();

    for (int i = 0; i < pending.length; i++) {
      final record = pending[i];
      final success = await UploadService.I.uploadRecord(
        id: record.id,
        photoPath: record.photoPath,
        value: record.value,
        surveyType: record.surveyType.label,
        note: record.note,
        timestamp: record.timestamp,
      );

      if (success) {
        await StorageService.I.markUploaded([record.id]);
      }
      uploadProgress.value = i + 1;
    }

    _loadRecords();
    isUploading.value = false;

    final successCount = records.where((r) => r.uploadStatus == UploadStatus.uploaded).length;
    Get.snackbar(
      '업로드 완료',
      '${pending.length}건 중 ${pending.length}건 전송 완료',
      snackPosition: SnackPosition.bottom,
      backgroundColor: Colors.green[700],
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  void editRecord(SurveyRecord record) {
    final valueCtrl = TextEditingController(text: record.value.toString());
    final noteCtrl = TextEditingController(text: record.note);

    Get.dialog(
      AlertDialog(
        title: const Text('수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: valueCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '수치 (mm)',
                border: OutlineInputBorder(),
                suffixText: 'mm',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '비고',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('취소')),
          ElevatedButton(
            onPressed: () async {
              final val = double.tryParse(valueCtrl.text.trim());
              if (val == null) return;
              final updated = record.copyWith(value: val, note: noteCtrl.text.trim());
              await StorageService.I.updateRecord(updated);
              _loadRecords();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white),
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
