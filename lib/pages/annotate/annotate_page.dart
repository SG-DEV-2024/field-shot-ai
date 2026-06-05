import 'dart:io';
import 'package:ai_camera/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/pages/annotate/annotate_controller.dart';

const _kBlue = AppColors.blue600;
const _kRed = AppColors.red500;
const _kAmber = AppColors.amber500;
const _kInk = AppColors.ink900;

// 단계/라디오 카드 톤 (목업 S-004/S-007 기준)
const _kBlueBorder = Color(0xFFBFDBFE);
const _kBlueBg = Color(0xFFF8FBFF);
const _kRedBorder = Color(0xFFFECACA);
const _kRedBg = Color(0xFFFFF7F7);
const _kAmberBorder = Color(0xFFFCD34D);
const _kAmberBg = Color(0xFFFFFBEB);
const _kDoneGreen = Color(0xFF22C55E);
const _kDoneBorder = Color(0xFFBBF7D0);
const _kDoneBg = Color(0xFFF0FDF4);
const _kNumGrey = Color(0xFF94A3B8);
const _kLine = Color(0xFFE5E7EB);

class AnnotatePage extends StatelessWidget {
  const AnnotatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AnnotateController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(ctrl),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _photoFrame(ctrl),
                    const SizedBox(height: 12),
                    _steps(ctrl),
                    if (ctrl.isHole) _radioCards(ctrl),
                    const SizedBox(height: 8),
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

  // ============================================================
  // 상단 바 (← 제목 + subtype 칩)
  // ============================================================
  Widget _appBar(AnnotateController ctrl) {
    final title = ctrl.isHole ? '기준점 지정' : '측정점 지정';
    final chipBg = ctrl.isHole ? AppColors.amber100 : const Color(0xFFDBEAFE);
    final chipFg = ctrl.isHole ? const Color(0xFF92400E) : AppColors.blue800;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 16, 8),
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
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kInk)),
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

  // ============================================================
  // 사진 프레임 — 1:1 정사각 · BoxFit.cover(꽉 채움) · 둥근 테두리
  // 측정 지점(●) + 라벨(pill) + stem(점선) 분리, 각각 독립 드래그.
  // ============================================================
  Widget _photoFrame(AnnotateController ctrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.ink900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: LayoutBuilder(builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            ctrl.setPreviewSize(size); // cover 가시영역 계산용 (점·라벨 프레임 내 clamp)
            final scale = ctrl.scaleFor(size);
            return Obx(() {
              // Obx 추적 보장: 좌표 observable을 최상단에서 무조건 읽는다.
              final start = ctrl.startPoint.value;
              final end = ctrl.endPoint.value;
              final lip = ctrl.holeLip.value;
              final tape = ctrl.tapeReading.value;
              final startL = ctrl.startLabel.value;
              final endL = ctrl.endLabel.value;
              final lipL = ctrl.holeLipLabel.value;
              final tapeL = ctrl.tapeReadingLabel.value;

              final markers = <_MarkerSpec>[];
              if (ctrl.isHole) {
                if (lip != null) {
                  markers.add(_MarkerSpec(lip, lipL ?? lip, _kAmber, '홀 입구',
                      ctrl.moveHoleLip, ctrl.moveHoleLipLabel));
                }
                if (tape != null) {
                  markers.add(_MarkerSpec(tape, tapeL ?? tape, _kBlue, '읽기 위치',
                      ctrl.moveTape, ctrl.moveTapeLabel));
                }
              } else {
                if (start != null) {
                  markers.add(_MarkerSpec(start, startL ?? start, _kBlue, '시작면',
                      ctrl.moveStart, ctrl.moveStartLabel));
                }
                if (end != null) {
                  markers.add(_MarkerSpec(end, endL ?? end, _kRed, '끝면',
                      ctrl.moveEnd, ctrl.moveEndLabel));
                }
              }

              Offset toPv(Offset o) => ctrl.toPreview(o, size);

              final children = <Widget>[
                // 사진. 탭 = 측정점 배치/이동(손 떼는 순간). 드래그 = 그 자리에서 찍고
                // 손 안 떼고 그대로 이어 끌기. (tapUp ↔ panStart 는 제스처 아레나에서 상호배타)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (d) => ctrl.tapPlace(ctrl.toOriginal(d.localPosition, size)),
                    onPanStart: (d) => ctrl.tapPlace(ctrl.toOriginal(d.localPosition, size)),
                    onPanUpdate: (d) => ctrl.dragActiveTo(ctrl.toOriginal(d.localPosition, size)),
                    child: ctrl.photoPath.isEmpty
                        ? const SizedBox.expand()
                        : Image.file(File(ctrl.photoPath), fit: BoxFit.cover),
                  ),
                ),
                // stem 레이어 (point ↔ label 점선)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _StemPainter(markers, toPv)),
                  ),
                ),
              ];

              // 라벨(아래) → 측정 지점(위) 순서로 쌓아 겹칠 때 점이 우선 잡히게.
              for (final m in markers) {
                final lp = toPv(m.label);
                children.add(Positioned(
                  left: lp.dx,
                  top: lp.dy,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, -0.5),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanUpdate: (d) => m.onLabelDrag(d.delta / scale),
                      child: _LabelPill(color: m.color, text: m.text),
                    ),
                  ),
                ));
              }
              for (final m in markers) {
                final pp = toPv(m.point);
                children.add(Positioned(
                  left: pp.dx - 18,
                  top: pp.dy - 18,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (d) => m.onPointDrag(d.delta / scale),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Center(child: _PointDot(color: m.color)),
                    ),
                  ),
                ));
              }

              return Stack(children: children);
            });
          }),
        ),
      ),
    );
  }

  // ============================================================
  // 단계 카드
  // ============================================================
  Widget _steps(AnnotateController ctrl) {
    if (!ctrl.isHole) {
      // 폭/간격: 두 마커가 사전 좌표로 항상 표시 → 정보형 단계 카드 2개.
      // 폭/간격은 두 마커가 사전 좌표로 항상 표시 → 항상 톤(시작 blue·끝 red).
      return Column(
        children: [
          _StepCard(num: 1, title: '측정 시작점을 맞추세요', tone: _ToneSpec.blue, done: true),
          _StepCard(num: 2, title: '측정 끝점을 맞추세요', tone: _ToneSpec.red, done: true),
        ],
      );
    }
    // 홀 깊이: 사진에서 순차 터치 → 완료(✓) 상태 반영.
    return Obx(() {
      final lipDone = ctrl.holeLip.value != null;
      final tapeDone = ctrl.tapeReading.value != null;
      return Column(
        children: [
          _StepCard(num: 1, title: '홀 입구 기준점을 터치', tone: _ToneSpec.amber, done: lipDone),
          _StepCard(num: 2, title: '줄자 읽기 위치를 터치', tone: _ToneSpec.blue, done: tapeDone),
        ],
      );
    });
  }

  // ============================================================
  // 라디오 카드 (홀 깊이 3·4단계)
  // ============================================================
  Widget _radioCards(AnnotateController ctrl) {
    return Column(
      children: [
        _RadioCard(
          num: 3,
          question: '줄자 시작점이 보이나요?',
          options: const {
            'visible': '시작점이 면에 노출됨 (보임)',
            'hidden_behind_lip': '내부에 가려져 보이지 않음',
          },
          valueRx: ctrl.startVisibility,
        ),
        _RadioCard(
          num: 4,
          question: '줄자 끝이 홀 바닥에 닿았나요?',
          options: const {
            'yes': '닿음 (바닥에 접촉)',
            'no': '닿지 않음 (떠 있음)',
            'unknown': '모름',
          },
          valueRx: ctrl.contactConfirm,
        ),
      ],
    );
  }

  // ============================================================
  // 하단 버튼
  // ============================================================
  Widget _bottomBar(AnnotateController ctrl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _kLine)),
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
                  onPressed: ctrl.isValid ? ctrl.next : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kBlue,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: const Color(0xFF9CA3AF),
                    elevation: 0,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('다음 · 수치 입력',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
                )),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 단계 카드 톤 + 위젯
// ============================================================
class _ToneSpec {
  final Color border;
  final Color bg;
  final Color numBg;
  const _ToneSpec(this.border, this.bg, this.numBg);

  static const blue = _ToneSpec(_kBlueBorder, _kBlueBg, _kBlue);
  static const red = _ToneSpec(_kRedBorder, _kRedBg, _kRed);
  static const amber = _ToneSpec(_kAmberBorder, _kAmberBg, _kAmber);
}

class _StepCard extends StatelessWidget {
  final int num;
  final String title;
  final _ToneSpec tone;
  final bool done;
  const _StepCard({required this.num, required this.title, required this.tone, this.done = false});

  @override
  Widget build(BuildContext context) {
    // 미배치 = 회색톤 / 배치(done) = 해당 톤(①주황·②파랑) — 번호·체크·배경·테두리 모두.
    final border = done ? tone.border : _kLine;
    final bg = done ? tone.bg : Colors.white;
    final numBg = done ? tone.numBg : _kNumGrey;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1.5),
      ),
      child: Row(
        children: [
          _NumCircle(num: num, bg: numBg),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 13.5, fontWeight: FontWeight.w800, color: _kInk, letterSpacing: -0.2),
            ),
          ),
          if (done) Icon(Icons.check, color: tone.numBg, size: 18),
        ],
      ),
    );
  }
}

class _NumCircle extends StatelessWidget {
  final int num;
  final Color bg;
  final double size;
  const _NumCircle({required this.num, required this.bg, this.size = 26});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text('$num',
          style: TextStyle(
              color: Colors.white, fontSize: size * 0.5, fontWeight: FontWeight.w800)),
    );
  }
}

// ============================================================
// 라디오 카드
// ============================================================
class _RadioCard extends StatelessWidget {
  final int num;
  final String question;
  final Map<String, String> options;
  final Rxn<String> valueRx;
  const _RadioCard(
      {required this.num, required this.question, required this.options, required this.valueRx});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = valueRx.value;
      final done = selected != null;
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        decoration: BoxDecoration(
          color: done ? _kDoneBg : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: done ? _kDoneBorder : _kLine, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _NumCircle(num: num, bg: done ? _kDoneGreen : _kNumGrey, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(question,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w800, color: _kInk, letterSpacing: -0.2)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...options.entries.map((e) {
              final isSel = selected == e.key;
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => valueRx.value = e.key,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: Row(
                    children: [
                      _RadioMark(checked: isSel),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(e.value,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: _kInk,
                            )),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

class _RadioMark extends StatelessWidget {
  final bool checked;
  const _RadioMark({required this.checked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: checked ? _kBlue : const Color(0xFFCBD5E1), width: 1.8),
      ),
      child: checked
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: _kBlue, shape: BoxShape.circle),
              ),
            )
          : null,
    );
  }
}

// ============================================================
// 마커 (측정 지점 + 라벨 + stem)
// ============================================================
/// 마커 1개 = 측정 지점(point) + 라벨(label) + stem. 좌표는 모두 원본 픽셀.
class _MarkerSpec {
  final Offset point;
  final Offset label;
  final Color color;
  final String text;
  final void Function(Offset deltaOriginal) onPointDrag;
  final void Function(Offset deltaOriginal) onLabelDrag;
  const _MarkerSpec(
      this.point, this.label, this.color, this.text, this.onPointDrag, this.onLabelDrag);
}

/// 측정 지점(●) — 16px 흰 원 + 색 외곽.
class _PointDot extends StatelessWidget {
  final Color color;
  const _PointDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1))],
      ),
    );
  }
}

/// 라벨 pill — 측정 지점과 분리, 독립 드래그.
class _LabelPill extends StatelessWidget {
  final Color color;
  final String text;
  const _LabelPill({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 3)],
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: -0.1)),
    );
  }
}

/// stem — 각 마커의 point ↔ label 을 잇는 점선 (자동 갱신).
class _StemPainter extends CustomPainter {
  final List<_MarkerSpec> markers;
  final Offset Function(Offset) toPreview;
  _StemPainter(this.markers, this.toPreview);

  @override
  void paint(Canvas canvas, Size size) {
    for (final m in markers) {
      final p = toPreview(m.point);
      final l = toPreview(m.label);
      _dashedLine(canvas, p, l, m.color);
    }
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    const dash = 4.0, gap = 3.0;
    final total = (b - a).distance;
    if (total < 0.5) return;
    final dir = (b - a) / total;
    double t = 0;
    while (t < total) {
      final segEnd = (t + dash).clamp(0.0, total);
      canvas.drawLine(a + dir * t, a + dir * segEnd, paint);
      t += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _StemPainter old) => true;
}
