import 'package:flutter/material.dart';
import 'package:ai_camera/theme/app_colors.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/models/measurement_subtype.dart';

/// 카메라 가이드박스 모양 모드.
enum GuideBoxMode {
  rectHorizontalShort, // 탄산화 (기존 기본): 가로 사각형 + 내부 원
  rectHorizontalWide, // 폭/간격: 가로 긴 사각형 + 좌/우 핸들
  ovalVertical, // 홀 깊이: 세로 타원
}

GuideBoxMode resolveGuideBoxMode(SurveyType t, MeasurementSubtype? s) {
  if (t == SurveyType.carbonation) return GuideBoxMode.rectHorizontalShort;
  switch (s) {
    case MeasurementSubtype.wallOrMemberWidth:
    case MeasurementSubtype.memberGap:
      return GuideBoxMode.rectHorizontalWide;
    case MeasurementSubtype.holeDepth:
      return GuideBoxMode.ovalVertical;
    default:
      return GuideBoxMode.rectHorizontalShort;
  }
}

/// 가이드박스 표준 색 (규격조사 v0.2): 노랑 #facc15 / 잠금 빨강 #ef4444
const Color kGuideYellow = AppColors.yellow400;
const Color kGuideRed = AppColors.red500;
const Color kGuideGreen = Color(0xFF22C55E);

/// 점선 사각형 페인터 (radius 옵션).
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final double radius;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 2.5,
    this.dashWidth = 10,
    this.dashGap = 6,
    this.radius = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));
    _drawDashed(canvas, path, paint, dashWidth, dashGap);
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter old) => old.color != color;
}

/// 점선 원/타원 페인터. [fraction]은 가로/세로 비율로 타원 크기 지정.
class DashedOvalPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final Size ovalRatio; // 너비/높이 비율 (0..1)

  DashedOvalPainter({
    required this.color,
    this.strokeWidth = 2.5,
    this.dashWidth = 8,
    this.dashGap = 5,
    this.ovalRatio = const Size(1, 1),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final w = size.width * ovalRatio.width;
    final h = size.height * ovalRatio.height;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: w,
      height: h,
    );
    final path = Path()..addOval(rect);
    _drawDashed(canvas, path, paint, dashWidth, dashGap);
  }

  @override
  bool shouldRepaint(covariant DashedOvalPainter old) => old.color != color;
}

void _drawDashed(Canvas canvas, Path path, Paint paint, double dw, double dg) {
  for (final m in path.computeMetrics()) {
    double d = 0;
    while (d < m.length) {
      canvas.drawPath(m.extractPath(d, d + dw), paint);
      d += dw + dg;
    }
  }
}
