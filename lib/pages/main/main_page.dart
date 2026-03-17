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
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '조사할 항목을 선택하세요',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SurveyCard(
                icon: Icons.straighten,
                title: '탄산화 조사',
                subtitle: '(버니어 캘리퍼스 수치 인식)',
                enabled: true,
                onTap: () => ctrl.goToCamera(SurveyType.carbonation),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SurveyCard(
                icon: Icons.architecture,
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
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '현장 데이터 수집기',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: const Row(
              children: [
                Icon(Icons.language, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text('ON', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomStats(MainController ctrl) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '오늘의 수집 현황',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: ctrl.goToArchive,
                child: const Text(
                  '보관함 보기',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1E3A8A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _StatItem(label: '총 촬영', value: '${ctrl.totalToday}', color: Colors.black87),
                  const SizedBox(width: 24),
                  _StatItem(label: '미전송 대기', value: '${ctrl.pendingCount}', color: Colors.red),
                  const SizedBox(width: 24),
                  _StatItem(label: '전송 완료', value: '${ctrl.uploadedCount}', color: Colors.green[700]!),
                ],
              ),
            )),
        const SizedBox(height: 16),
        Obx(() => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: ctrl.pendingCount.value > 0 ? ctrl.goToArchive : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    '${ctrl.pendingCount}건 일괄 전송 (서버 업로드)',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

class _SurveyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  const _SurveyCard({
    required this.icon,
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFEFF6FF) : Colors.grey[100],
          border: Border.all(
            color: enabled ? const Color(0xFF1E3A8A) : Colors.grey[300]!,
            width: enabled ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 36,
              color: enabled ? const Color(0xFF1E3A8A) : Colors.grey[400],
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: enabled ? Colors.black87 : Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: enabled ? const Color(0xFF1E3A8A) : Colors.grey[400],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
