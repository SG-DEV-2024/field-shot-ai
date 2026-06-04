import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_camera/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:ai_camera/models/measurement_subtype.dart';
import 'package:ai_camera/pages/survey_type_select/survey_type_select_controller.dart';

const _kBlue = AppColors.blue600;
const _kInk = AppColors.ink900;

class SurveyTypeSelectPage extends StatelessWidget {
  const SurveyTypeSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(SurveyTypeSelectController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 14, 12, 12),
              child: Row(
                children: [
                  InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Get.back(),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back, color: _kInk, size: 22),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '규격 조사',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kInk),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
              child: Text(
                '측정 유형을 선택하세요',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                children: [
                  _SubtypeCard(
                    subtype: MeasurementSubtype.wallOrMemberWidth,
                    onTap: () => ctrl.select(MeasurementSubtype.wallOrMemberWidth),
                  ),
                  const SizedBox(height: 12),
                  _SubtypeCard(
                    subtype: MeasurementSubtype.memberGap,
                    onTap: () => ctrl.select(MeasurementSubtype.memberGap),
                  ),
                  const SizedBox(height: 12),
                  _SubtypeCard(
                    subtype: MeasurementSubtype.holeDepth,
                    onTap: () => ctrl.select(MeasurementSubtype.holeDepth),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubtypeCard extends StatelessWidget {
  final MeasurementSubtype subtype;
  final VoidCallback onTap;

  const _SubtypeCard({required this.subtype, required this.onTap});

  String get _iconAsset {
    switch (subtype) {
      case MeasurementSubtype.wallOrMemberWidth:
        return 'assets/icons/icon_subtype_width.svg';
      case MeasurementSubtype.memberGap:
        return 'assets/icons/icon_subtype_gap.svg';
      case MeasurementSubtype.holeDepth:
        return 'assets/icons/icon_subtype_hole.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.blue50,
          border: Border.all(color: _kBlue, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // HTML 기준: icon-slot 44×44 투명 슬롯에 네이티브 44 1:1 (흰 박스 없음)
            SizedBox(
              width: 44,
              height: 44,
              child: SvgPicture.asset(_iconAsset, width: 44, height: 44),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtype.label,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kInk),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtype.description,
                    style: const TextStyle(fontSize: 13, color: _kBlue),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _kBlue),
          ],
        ),
      ),
    );
  }
}
