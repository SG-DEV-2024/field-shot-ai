import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/pages/dimension_input/dimension_input_controller.dart';

const _kBlue = Color(0xFF2563EB);
const _kBlueDeep = Color(0xFF1E40AF);
const _kRed = Color(0xFFDC2626);
const _kAmber = Color(0xFFF59E0B);
const _kInk = Color(0xFF111827);

class DimensionInputPage extends StatelessWidget {
  const DimensionInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DimensionInputController());
    final accent = ctrl.isHole ? _kAmber : _kBlue;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(ctrl),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ctrl.isHole) ...[
                      _InputField(label: '1. 보이는 줄자 숫자', accent: accent, controller: ctrl.visibleValueCtrl, hint: '홀 입구에서 보이는 눈금'),
                    ] else ...[
                      _InputField(label: '1. 줄자 시작값', accent: accent, controller: ctrl.startValueCtrl, hint: '줄자 시작 눈금'),
                      const SizedBox(height: 14),
                      _InputField(label: '2. 줄자 끝값', accent: accent, controller: ctrl.endValueCtrl, hint: '줄자 끝 눈금'),
                      Obx(() => ctrl.endError.value
                          ? const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text('끝값은 시작값보다 커야 합니다',
                                  style: TextStyle(color: _kRed, fontSize: 11.5, fontWeight: FontWeight.w600)),
                            )
                          : const SizedBox.shrink()),
                    ],
                    const SizedBox(height: 16),
                    _resultCard(ctrl),
                    const SizedBox(height: 16),
                    const Text('비고 (선택)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kInk)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: ctrl.noteCtrl,
                      maxLines: null,
                      minLines: 5,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: '특이사항이 있으면 입력하세요\n예) 위치, 환경, 줄자 처짐, 가림 등',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: _kBlue, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _bottomBar(ctrl),
          ],
        ),
      ),
    );
  }

  Widget _appBar(DimensionInputController ctrl) {
    final chipBg = ctrl.isHole ? const Color(0xFFFEF3C7) : const Color(0xFFDBEAFE);
    final chipFg = ctrl.isHole ? const Color(0xFF92400E) : _kBlueDeep;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 16, 6),
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Get.back(),
            child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, color: _kInk, size: 22)),
          ),
          const SizedBox(width: 4),
          const Text('수치 입력', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kInk)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: chipBg, borderRadius: BorderRadius.circular(999)),
            child: Text(
              ctrl.subtype?.shortLabel ?? '규격',
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: chipFg),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultCard(DimensionInputController ctrl) {
    return Obx(() {
      final valid = ctrl.isValid.value;
      final label = ctrl.isHole ? '깊이 측정값' : '자동 계산 측정값';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: valid ? const Color(0xFFEFF6FF) : const Color(0xFFFEF2F2),
          border: Border.all(color: valid ? _kBlue : const Color(0xFFFECACA), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: valid ? _kBlueDeep : const Color(0xFF991B1B))),
            Text(
              valid ? '${_fmt(ctrl.measuredValue.value)} mm' : '—',
              style: TextStyle(
                fontSize: valid ? 22 : 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
                color: valid ? _kBlueDeep : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  Widget _bottomBar(DimensionInputController ctrl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: OutlinedButton.icon(
              onPressed: ctrl.retake,
              icon: const Icon(Icons.camera_alt_outlined, size: 18),
              label: const Text('다시 촬영'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[400]!),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Obx(() => ElevatedButton(
                  onPressed: (ctrl.isValid.value && !ctrl.isSaving.value) ? ctrl.save : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kBlue,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: const Color(0xFF9CA3AF),
                    elevation: 0,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: ctrl.isSaving.value
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('저장 후 계속 촬영',
                          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
                )),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final Color accent;
  final TextEditingController controller;
  final String hint;
  const _InputField({required this.label, required this.accent, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kInk)),
            const Text('mm', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'Pretendard'),
            suffixText: 'mm',
            suffixStyle: const TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontWeight: FontWeight.w600),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
