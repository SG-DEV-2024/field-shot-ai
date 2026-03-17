import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/pages/camera/camera_controller.dart';

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
              Positioned.fill(
                child: CameraPreview(ctrl.cameraController),
              ),
              // UI 오버레이
              Positioned.fill(
                child: Column(
                  children: [
                    _buildTopBar(ctrl),
                    const SizedBox(height: 8),
                    _buildGuideLabel(),
                    const SizedBox(height: 16),
                    _buildGuideBox(),
                    const Spacer(),
                    _buildBottomControls(ctrl),
                  ],
                ),
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
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

  Widget _buildGuideBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 노란 점선 사각형 가이드박스
            CustomPaint(
              painter: _DashedRectPainter(),
              child: const SizedBox.expand(),
            ),
            // 크로스헤어 원 (점선)
            CustomPaint(
              painter: _DashedCirclePainter(),
              child: const SizedBox.expand(),
            ),
            // 크로스헤어 중심선
            const _Crosshair(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(CameraController2 ctrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          // 줌 선택
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ZoomButton(label: '1x', zoom: 1.0, ctrl: ctrl),
                  const SizedBox(width: 8),
                  _ZoomButton(label: '2x', zoom: 2.0, ctrl: ctrl),
                  const SizedBox(width: 8),
                  _ZoomButton(label: '3x', zoom: 3.0, ctrl: ctrl),
                ],
              )),
          const SizedBox(height: 20),
          // 썸네일 + 셔터
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 마지막 촬영 썸네일
              Obx(() => _Thumbnail(path: ctrl.lastPhotoPath.value)),
              // 셔터 버튼
              Obx(() => GestureDetector(
                    onTap: ctrl.isCapturing.value ? null : ctrl.capture,
                    child: _ShutterButton(isCapturing: ctrl.isCapturing.value),
                  )),
              // 균형용 빈 공간
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
  final double zoom;
  final CameraController2 ctrl;

  const _ZoomButton({required this.label, required this.zoom, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isActive = ctrl.zoomLevel.value == zoom;
    return GestureDetector(
      onTap: () => ctrl.setZoom(zoom),
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
  const _ShutterButton({required this.isCapturing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        color: isCapturing ? Colors.grey : Colors.white,
      ),
      child: isCapturing
          ? const Padding(
              padding: EdgeInsets.all(18),
              child: CircularProgressIndicator(color: Colors.black54, strokeWidth: 2),
            )
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
  const _Crosshair();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(painter: _CrosshairPainter()),
    );
  }
}

// 노란 점선 사각형
class _DashedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 10.0;
    const dashGap = 6.0;
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _drawDashedPath(canvas, path, paint, dashWidth, dashGap);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashWidth, double dashGap) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 노란 점선 원
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

    final metrics = path.computeMetrics();
    const dashWidth = 8.0;
    const dashGap = 5.0;
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 크로스헤어 선
class _CrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF34D399)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), paint);
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), paint);

    // 중심 점
    canvas.drawCircle(Offset(cx, cy), 3, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
