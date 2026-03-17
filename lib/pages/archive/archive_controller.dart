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

    final ctx = Get.context;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('${pending.length}건 전송 완료'),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void editRecord(SurveyRecord record) {
    final valueCtrl = TextEditingController(text: record.value.toString());
    final noteCtrl = TextEditingController(text: record.note);

    Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '액정에 표시된 수치를 입력해주세요',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: valueCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixText: 'mm',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '비고 (선택)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '특이사항이나 메모를 입력하세요...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
