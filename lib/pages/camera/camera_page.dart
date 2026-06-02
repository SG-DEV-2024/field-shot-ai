import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/pages/camera/camera_controller.dart';
import 'package:ai_camera/routes/app_pages.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(CameraController2());

    return Scaffold(
      backgroundColor: const Color(0xFF1A2332),
      body: SafeArea(
        child: Obx(() {
          if (!ctrl.isInitialized.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          return Stack(
            children: [
              // 카메라 프리뷰 (전체 배경)
              Positioned.fill(child: CameraPreview(ctrl.cameraController)),

              // 가이드 라벨 (상단 중앙)
              Positioned(
                top: 60,
                left: 20,
                right: 20,
                child: Center(child: _buildGuideLabel()),
              ),

              // 가이드박스 (화면 정중앙)
              Center(child: _buildGuideBox(ctrl)),

              // 상단 바 (뒤로 + 플래시)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopBar(ctrl),
              ),

              // 하단 컨트롤
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomControls(ctrl),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(CameraController2 ctrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const Spacer(),
          Obx(() => GestureDetector(
                onTap: ctrl.toggleFlash,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Text(
                    ctrl.flashLabel,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildGuideLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        '가이드 박스 안에 숫자가 꽉 차게 맞춰주세요',
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildGuideBox(CameraController2 ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(painter: _DashedRectPainter(), child: const SizedBox.expand()),
            CustomPaint(painter: _DashedCirclePainter(), child: const SizedBox.expand()),
            // 기울기에 따라 크로스헤어 회전
            Obx(() => Transform.rotate(
                  angle: ctrl.tiltAngle.value,
                  child: _Crosshair(isLevel: ctrl.isLevel.value),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(CameraController2 ctrl) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 줌 선택
          Obx(() {
            final currentZoom = ctrl.zoomLevel.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ZoomButton(label: '1x', isActive: currentZoom == 1.0, onTap: () => ctrl.setZoom(1.0)),
                const SizedBox(width: 8),
                _ZoomButton(label: '2x', isActive: currentZoom == 2.0, onTap: () => ctrl.setZoom(2.0)),
                const SizedBox(width: 8),
                _ZoomButton(label: '3x', isActive: currentZoom == 3.0, onTap: () => ctrl.setZoom(3.0)),
              ],
            );
          }),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.archive),
                    child: _Thumbnail(path: ctrl.lastPhotoPath.value),
                  )),
              Obx(() => GestureDetector(
                    onTap: (ctrl.isCapturing.value || ctrl.isLocked.value) ? null : ctrl.capture,
                    child: _ShutterButton(
                      isCapturing: ctrl.isCapturing.value,
                      isLocked: ctrl.isLocked.value,
                    ),
                  )),
              const SizedBox(width: 60),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _ZoomButton({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFBBF24) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
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
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isLocked ? Colors.red : Colors.white,
          width: 4,
        ),
        color: isCapturing ? Colors.grey : (isLocked ? Colors.red.withOpacity(0.3) : Colors.white),
      ),
      child: isCapturing
          ? const Padding(
              padding: EdgeInsets.all(18),
              child: CircularProgressIndicator(color: Colors.black54, strokeWidth: 2),
            )
          : isLocked
              ? const Icon(Icons.lock, color: Colors.white, size: 28)
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
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white54, width: 2),
        color: Colors.black54,
      ),
      clipBehavior: Clip.hardEdge,
      child: path.isEmpty
          ? const Icon(Icons.image, color: Colors.white38, size: 28)
          : Image.file(File(path), fit: BoxFit.cover),
    );
  }
}

class _Crosshair extends StatelessWidget {
  final bool isLevel;
  const _Crosshair({required this.isLevel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(painter: _CrosshairPainter(isLevel: isLevel)),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _drawDashed(canvas, path, paint);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    const dw = 10.0, dg = 6.0;
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + dw), paint);
        d += dw + dg;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.height * 0.38;
    final path = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    const dw = 8.0, dg = 5.0;
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + dw), paint);
        d += dw + dg;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _CrosshairPainter extends CustomPainter {
  final bool isLevel;
  _CrosshairPainter({required this.isLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final color = isLevel ? const Color(0xFF34D399) : Colors.red;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2, cy = size.height / 2;
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), paint);
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), paint);
    canvas.drawCircle(Offset(cx, cy), 3, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _CrosshairPainter old) => old.isLevel != isLevel;
}
