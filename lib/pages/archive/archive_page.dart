import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/pages/archive/archive_controller.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ArchiveController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Obx(() {
                if (ctrl.records.isEmpty) {
                  return Center(
                    child: Text('오늘 수집한 데이터가 없습니다', style: TextStyle(color: Colors.grey[500])),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        '오늘 수집한 데이터 (${ctrl.records.length})',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: ctrl.records.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _RecordCard(
                          record: ctrl.records[i],
                          onEdit: () => ctrl.editRecord(ctrl.records[i]),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            _buildUploadButton(ctrl),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 20, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          const Text('사진 보관함', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildUploadButton(ArchiveController ctrl) {
    return Obx(() {
      final count = ctrl.pendingCount;
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (count > 0 && !ctrl.isUploading.value) ? ctrl.uploadAll : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: ctrl.isUploading.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Obx(() => Text(
                            '업로드 중... (${ctrl.uploadProgress}/${ctrl.pendingCount + ctrl.uploadProgress.value})',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                : Text(
                    count > 0 ? '미전송 데이터 (${count}건) 업로드' : '모든 데이터 전송 완료',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      );
    });
  }
}

class _RecordCard extends StatelessWidget {
  final SurveyRecord record;
  final VoidCallback onEdit;

  const _RecordCard({required this.record, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isPending = record.uploadStatus == UploadStatus.pending;
    final timeStr =
        '${record.timestamp.hour.toString().padLeft(2, '0')}:${record.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // 썸네일
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[200],
            ),
            clipBehavior: Clip.hardEdge,
            child: record.photoPath.isNotEmpty && File(record.photoPath).existsSync()
                ? Image.file(File(record.photoPath), fit: BoxFit.cover)
                : const Icon(Icons.image, color: Colors.grey, size: 28),
          ),
          const SizedBox(width: 12),
          // 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$timeStr | ${record.surveyType.label}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.value} mm',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                _StatusBadge(isPending: isPending),
              ],
            ),
          ),
          // 수정 버튼 (대기중인 경우만)
          if (isPending)
            TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('수정', style: TextStyle(fontSize: 13)),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isPending;
  const _StatusBadge({required this.isPending});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPending ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isPending ? '대기중' : '전송완료',
          style: TextStyle(
            fontSize: 12,
            color: isPending ? Colors.red : Colors.green[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
