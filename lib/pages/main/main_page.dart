import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/pages/main/main_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(MainController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(ctrl),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '조사할 항목을 선택하세요',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  letterSpacing: 0.1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SurveyCard(
                imagePath: 'assets/image/icon_ruler.png',
                title: '탄산화 조사',
                subtitle: '(버니어 캘리퍼스 수치 인식)',
                enabled: true,
                onTap: () => ctrl.goToCamera(SurveyType.carbonation),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SurveyCard(
                imagePath: 'assets/image/icon_triangle_ruler.png',
                title: '배근 간격 조사 (줄자)',
                subtitle: '서비스 준비 중...',
                enabled: false,
                onTap: null,
              ),
            ),
            const Spacer(),
            _buildBottomStats(ctrl),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(MainController ctrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Text(
              '현장 데이터 수집기',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                letterSpacing: -0.3,
              ),
            ),
          ),
          // ON/OFF 배지
          Obx(() {
            final online = ctrl.isOnline.value;
            return Container(
              decoration: BoxDecoration(
                color: online ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.language_rounded,
                    color: online ? const Color(0xFF16A34A) : Colors.grey[500],
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    online ? 'ON' : 'OFF',
                    style: TextStyle(
                      color: online ? const Color(0xFF16A34A) : Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF6B7280)),
            iconSize: 22,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomStats(MainController ctrl) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '오늘의 수집 현황',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              GestureDetector(
                onTap: ctrl.goToArchive,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Text(
                    '보관함 보기',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 통계 카드
          Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          label: '총 촬영',
                          value: '${ctrl.totalToday}',
                          color: const Color(0xFF111827),
                        ),
                      ),
                      const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
                      Expanded(
                        child: _StatItem(
                          label: '미전송 대기',
                          value: '${ctrl.pendingCount}',
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                      const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
                      Expanded(
                        child: _StatItem(
                          label: '전송 완료',
                          value: '${ctrl.uploadedCount}',
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 12),
          // 전송 버튼
          Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (ctrl.pendingCount.value > 0 && !ctrl.isUploading.value)
                      ? ctrl.uploadPending
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: const Color(0xFF9CA3AF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: ctrl.isUploading.value
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text('전송 중...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        )
                      : Text(
                          ctrl.pendingCount.value > 0
                              ? '${ctrl.pendingCount}건 일괄 전송 (서버 업로드)'
                              : '전송할 데이터가 없습니다',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                ),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SurveyCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  const _SurveyCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
          border: Border.all(
            color: enabled ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
            width: enabled ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 36,
              height: 36,
              color: enabled ? null : Colors.grey[400],
              colorBlendMode: BlendMode.srcIn,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: enabled ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: enabled ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}
