import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/models/measurement_subtype.dart';
import 'package:ai_camera/services/storage_service.dart';
import 'package:ai_camera/services/upload_service.dart';

const _kBlue = Color(0xFF2563EB);
const _kBlueDeep = Color(0xFF1E40AF);

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
      final success = await UploadService.I.uploadRecord(record);

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

  /// 수정 모달 — subtype별 3변형 분기 (S-009).
  void editRecord(SurveyRecord record) {
    if (record.surveyType == SurveyType.carbonation) {
      _carbonationDialog(record);
    } else if (record.measurementSubtype == MeasurementSubtype.holeDepth) {
      _holeDialog(record);
    } else {
      _widthGapDialog(record);
    }
  }

  Future<void> _commit(SurveyRecord updated) async {
    await StorageService.I.updateRecord(updated);
    _loadRecords();
    Get.back();
  }

  // ----- 탄산화: 단일 측정값 + 비고 -----
  void _carbonationDialog(SurveyRecord record) {
    final valueCtrl = TextEditingController(text: _fmt(record.value));
    final noteCtrl = TextEditingController(text: record.note);
    Get.dialog(_dialogShell(
      title: '측정값 수정',
      chip: '탄산화',
      instruction: '액정에 표시된 수치를 입력해주세요',
      body: [
        _numField(valueCtrl, 'mm'),
        const SizedBox(height: 14),
        _noteField(noteCtrl),
      ],
      onSave: () {
        final val = double.tryParse(valueCtrl.text.trim());
        if (val == null) return;
        _commit(record.copyWith(value: val, note: noteCtrl.text.trim()));
      },
    ));
  }

  // ----- 홀 깊이: 줄자 읽은 값 + 비고 -----
  void _holeDialog(SurveyRecord record) {
    final ann = record.annotation;
    final valueCtrl = TextEditingController(text: _fmt(ann?.visibleReadingValue ?? record.value));
    final noteCtrl = TextEditingController(text: record.note);
    Get.dialog(_dialogShell(
      title: '측정값 수정',
      chip: '홀 깊이',
      instruction: '홀 입구에서 보이는 줄자 숫자를 입력하세요',
      body: [
        _numField(valueCtrl, 'mm'),
        const SizedBox(height: 14),
        _noteField(noteCtrl),
      ],
      onSave: () {
        final v = double.tryParse(valueCtrl.text.trim());
        if (v == null || v <= 0) return;
        final newAnn = ann?.copyWith(visibleReadingValue: v, measuredValue: v);
        _commit(record.copyWith(value: v, note: noteCtrl.text.trim(), annotation: newAnn));
      },
    ));
  }

  // ----- 폭/간격: 시작값 + 끝값 + 자동계산 + 비고 -----
  void _widthGapDialog(SurveyRecord record) {
    final ann = record.annotation;
    final startCtrl = TextEditingController(text: _fmt(ann?.startValue ?? 0));
    final endCtrl = TextEditingController(text: _fmt(ann?.endValue ?? record.value));
    final noteCtrl = TextEditingController(text: record.note);

    Get.dialog(StatefulBuilder(builder: (context, setState) {
      final s = double.tryParse(startCtrl.text.trim());
      final e = double.tryParse(endCtrl.text.trim());
      final valid = s != null && e != null && e > s;
      final measured = valid ? e - s : null;
      return _dialogShellRaw(
        title: '측정값 수정',
        chip: '폭/간격',
        instruction: '줄자의 시작값과 끝값을 보정하세요. 측정값은 자동 계산됩니다.',
        body: [
          _labeledField('1. 줄자 시작값', startCtrl, (_) => setState(() {})),
          const SizedBox(height: 10),
          _labeledField('2. 줄자 끝값', endCtrl, (_) => setState(() {})),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: valid ? const Color(0xFFEFF6FF) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: valid ? _kBlue : const Color(0xFFFECACA)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('자동 계산 측정값',
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: valid ? _kBlueDeep : const Color(0xFF991B1B))),
                Text(valid ? '${_fmt(measured!)} mm' : '—',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        color: valid ? _kBlueDeep : const Color(0xFF9CA3AF))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _noteField(noteCtrl),
        ],
        onSave: () {
          if (!valid) return;
          final newAnn = ann?.copyWith(startValue: s, endValue: e, measuredValue: measured);
          _commit(record.copyWith(value: measured!, note: noteCtrl.text.trim(), annotation: newAnn));
        },
      );
    }));
  }

  // ===== 공통 다이얼로그 셸 =====
  Widget _dialogShell({
    required String title,
    required String chip,
    required String instruction,
    required List<Widget> body,
    required VoidCallback onSave,
  }) =>
      _dialogShellRaw(title: title, chip: chip, instruction: instruction, body: body, onSave: onSave);

  Widget _dialogShellRaw({
    required String title,
    required String chip,
    required String instruction,
    required List<Widget> body,
    required VoidCallback onSave,
  }) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF3F3F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(chip,
                      style: const TextStyle(
                          fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF92400E))),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(instruction,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), height: 1.4)),
            const SizedBox(height: 12),
            ...body,
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('취소')),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: _kBlueDeep,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          child: const Text('저장'),
        ),
      ],
    );
  }

  Widget _numField(TextEditingController c, String suffix) => TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixText: suffix,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      );

  Widget _labeledField(String label, TextEditingController c, ValueChanged<String> onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          TextField(
            controller: c,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              suffixText: 'mm',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      );

  Widget _noteField(TextEditingController c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('비고 (선택)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextField(
            controller: c,
            maxLines: 3,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: '특이사항이나 메모를 입력하세요...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      );

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }
}
