import 'dart:io';
import 'package:ai_camera/theme/app_colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/pages/camera/camera_controller.dart';
import 'package:ai_camera/routes/app_pages.dart';
import 'package:ai_camera/widgets/guide_box_painter.dart';

const _kBlue = AppColors.blue600;

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(CameraController2());

    return Scaffold(
      backgroundColor: AppColors.ink900,
      body: SafeArea(
        child: Obx(() {
          if (!ctrl.isInitialized.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          return Stack(
            children: [
              Positioned.fill(child: _CoverPreview(controller: ctrl.cameraController)),

              // 가이드 오버레이 (모드별)
              _buildGuide(ctrl),

              // 안내 버블
              Positioned(
                top: 84,
                left: 0,
                right: 0,
                child: Center(child: _HintBubble(ctrl: ctrl)),
              ),

              // 상단 바
              Positioned(top: 0, left: 0, right: 0, child: _TopBar(ctrl: ctrl)),

              // 하단 컨트롤
              Positioned(bottom: 0, left: 0, right: 0, child: _BottomControls(ctrl: ctrl)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildGuide(CameraController2 ctrl) {
    switch (ctrl.guideMode) {
      case GuideBoxMode.rectHorizontalShort:
        return Center(child: _CarbonationGuide(ctrl: ctrl));
      case GuideBoxMode.ovalVertical:
        return const Center(child: _OvalGuide());
      case GuideBoxMode.rectHorizontalWide:
        return Positioned.fill(child: _WideGuide(ctrl: ctrl));
    }
  }
}

// ============================================================
// 풀스크린 프리뷰 — previewSize 기준 BoxFit.cover 로 화면을 채움
// (Positioned.fill 직접 stretch 시 일부만 정상/나머지 뿌옇게 렌더되던 문제 해결)
// ============================================================
class _CoverPreview extends StatelessWidget {
  final CameraController controller;
  const _CoverPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    final preview = controller.value.previewSize;
    if (preview == null) return CameraPreview(controller);
    // previewSize는 가로(landscape) 기준 → portrait에서는 가로/세로를 바꿔 cover.
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: preview.height,
          height: preview.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

// ============================================================
// 탄산화 가이드: 사각형 + 내부 원 + 크로스헤어 (자세 잠금)
// ============================================================
class _CarbonationGuide extends StatelessWidget {
  final CameraController2 ctrl;
  const _CarbonationGuide({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final locked = ctrl.isLocked.value;
      final color = locked ? kGuideRed : kGuideYellow;
      return SizedBox(
        width: 248,
        height: 128,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: DashedRectPainter(color: color),
              child: const SizedBox.expand(),
            ),
            SizedBox(
              width: 84,
              height: 84,
              child: CustomPaint(
                painter: DashedOvalPainter(color: color, dashWidth: 7, dashGap: 5),
              ),
            ),
            Transform.rotate(
              angle: ctrl.tiltAngle.value,
              child: SizedBox(
                width: 36,
                height: 36,
                child: CustomPaint(painter: _CrosshairPainter(isLevel: ctrl.isLevel.value)),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ============================================================
// 홀 깊이 가이드: 세로 타원 + 중앙 십자
// ============================================================
class _OvalGuide extends StatelessWidget {
  const _OvalGuide();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      height: 236,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: DashedOvalPainter(color: kGuideYellow),
            child: const SizedBox.expand(),
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: CustomPaint(painter: _PlusPainter(color: kGuideYellow.withOpacity(0.7))),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 폭/간격 가이드: 가로 긴 사각형 + 좌/우 드래그 핸들 + 측정점 표시선
// ============================================================
class _WideGuide extends StatelessWidget {
  final CameraController2 ctrl;
  const _WideGuide({required this.ctrl});

  static const double _boxH = 130.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final h = c.maxHeight;
      final cy = h / 2;
      return Obx(() {
        final startX = ctrl.startHandleFrac.value * w;
        final endX = ctrl.endHandleFrac.value * w;
        final top = cy - _boxH / 2;
        return Stack(
          children: [
            // 가이드 박스 (start~end 구간)
            Positioned(
              left: startX,
              top: top,
              width: (endX - startX).clamp(1.0, w),
              height: _boxH,
              child: CustomPaint(painter: DashedRectPainter(color: kGuideYellow)),
            ),
            // 측정점 표시선 (시작=파랑 / 끝=빨강)
            Positioned(left: startX - 1, top: top, width: 2, height: _boxH, child: Container(color: _kBlue)),
            Positioned(left: endX - 1, top: top, width: 2, height: _boxH, child: Container(color: kGuideRed)),
            // 좌 핸들 (박스 외곽)
            _handle(
              cx: startX - 18,
              cy: cy,
              color: _kBlue,
              onDrag: (dx) => ctrl.dragStartHandle(ctrl.startHandleFrac.value + dx / w),
            ),
            // 우 핸들
            _handle(
              cx: endX + 18,
              cy: cy,
              color: kGuideRed,
              onDrag: (dx) => ctrl.dragEndHandle(ctrl.endHandleFrac.value + dx / w),
            ),
          ],
        );
      });
    });
  }

  Widget _handle({
    required double cx,
    required double cy,
    required Color color,
    required ValueChanged<double> onDrag,
  }) {
    return Positioned(
      left: cx - 16,
      top: cy - 16,
      width: 32,
      height: 32,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (d) => onDrag(d.delta.dx),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4)],
          ),
          child: const Icon(Icons.drag_indicator, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}

// ============================================================
// 상단 바
// ============================================================
class _TopBar extends StatelessWidget {
  final CameraController2 ctrl;
  const _TopBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.all(9),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
          ),
          Obx(() {
            final off = ctrl.flashMode.value == FlashMode2.off;
            final on = ctrl.flashMode.value == FlashMode2.on;
            final color = off
                ? const Color(0xFF9CA3AF)
                : (on ? AppColors.yellow400 : kGuideYellow);
            return GestureDetector(
              onTap: ctrl.toggleFlash,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, color: color, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      ctrl.flashLabel,
                      style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================
// 안내 버블
// ============================================================
class _HintBubble extends StatelessWidget {
  final CameraController2 ctrl;
  const _HintBubble({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // isLocked.value를 항상 먼저 읽는다 — 규격조사(isDimension)일 때
      // `!isDimension && isLocked.value` 식이 단락평가로 observable을 안 읽어
      // "the improper use of a GetX" 예외 → 릴리즈에서 회색 ErrorWidget(뿌연 막)이 됨.
      final lockedNow = ctrl.isLocked.value;
      final locked = !ctrl.isDimension && lockedNow;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: locked ? AppColors.red600.withValues(alpha: 0.88) : Colors.black.withOpacity(0.78),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          locked ? '기울기를 맞춰주세요 (셔터 잠금)' : ctrl.hintText,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      );
    });
  }
}

// ============================================================
// 하단 컨트롤
// ============================================================
class _BottomControls extends StatelessWidget {
  final CameraController2 ctrl;
  const _BottomControls({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.55),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 줌 pill
          Obx(() {
            final z = ctrl.zoomLevel.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _zoomBtn('1x', z == 1.0, () => ctrl.setZoom(1.0)),
                  _zoomBtn('2x', z == 2.0, () => ctrl.setZoom(2.0)),
                  _zoomBtn('3x', z == 3.0, () => ctrl.setZoom(3.0)),
                ],
              ),
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.archive),
                    child: _Thumbnail(path: ctrl.lastPhotoPath.value),
                  )),
              Obx(() => GestureDetector(
                    onTap: (ctrl.isCapturing.value || (!ctrl.isDimension && ctrl.isLocked.value))
                        ? null
                        : ctrl.capture,
                    child: _ShutterButton(
                      isCapturing: ctrl.isCapturing.value,
                      isLocked: !ctrl.isDimension && ctrl.isLocked.value,
                    ),
                  )),
              const SizedBox(width: 54),
            ],
          ),
        ],
      ),
    );
  }

  Widget _zoomBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? kGuideYellow : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.ink900 : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  final bool isCapturing;
  final bool isLocked;
  const _ShutterButton({required this.isCapturing, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isLocked ? kGuideRed : Colors.white.withOpacity(0.35),
          width: 4,
        ),
        color: isCapturing ? Colors.grey : (isLocked ? const Color(0xFF9CA3AF) : Colors.white),
      ),
      child: isCapturing
          ? const Padding(
              padding: EdgeInsets.all(18),
              child: CircularProgressIndicator(color: Colors.black54, strokeWidth: 2),
            )
          : isLocked
              ? const Icon(Icons.lock, color: Colors.white, size: 26)
              : null,
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String path;
  const _Thumbnail({required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        color: Colors.black54,
      ),
      clipBehavior: Clip.hardEdge,
      child: path.isEmpty
          ? const Icon(Icons.image, color: Colors.white38, size: 24)
          : Image.file(File(path), fit: BoxFit.cover),
    );
  }
}

// ============================================================
// 페인터
// ============================================================
class _CrosshairPainter extends CustomPainter {
  final bool isLevel;
  _CrosshairPainter({required this.isLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final color = isLevel ? kGuideGreen : kGuideRed;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2, cy = size.height / 2;
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), paint);
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), paint);
    canvas.drawCircle(Offset(cx, cy), 3, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _CrosshairPainter old) => old.isLevel != isLevel;
}

class _PlusPainter extends CustomPainter {
  final Color color;
  _PlusPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2, cy = size.height / 2;
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), paint);
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), paint);
  }

  @override
  bool shouldRepaint(covariant _PlusPainter old) => old.color != color;
}
