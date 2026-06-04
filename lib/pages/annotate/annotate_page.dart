import 'dart:io';
import 'package:ai_camera/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/pages/annotate/annotate_controller.dart';

const _kBlue = AppColors.blue600;
const _kRed = AppColors.red500;
const _kAmber = AppColors.amber500;
const _kInk = AppColors.ink900;

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
            // 사진 영역
            Expanded(child: _photoArea(ctrl)),
            // 안내 / 라디오 / 버튼
            _hintCard(ctrl),
            if (ctrl.isHole) _holeRadios(ctrl),
            _bottomBar(ctrl),
          ],
        ),
      ),
    );
  }

  Widget _appBar(AnnotateController ctrl) {
    final title = ctrl.isHole ? '기준점 지정' : '측정점 보정';
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 12, 10),
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
        ],
      ),
    );
  }

  Widget _photoArea(AnnotateController ctrl) {
    return Container(
      color: AppColors.ink900,
      child: LayoutBuilder(builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final scale = ctrl.scaleFor(size);
        return Obx(() {
          final children = <Widget>[
            // 사진
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) => ctrl.tapPlace(ctrl.toOriginal(d.localPosition, size)),
                child: ctrl.photoPath.isEmpty
                    ? const SizedBox.expand()
                    : Image.file(File(ctrl.photoPath), fit: BoxFit.contain),
              ),
            ),
          ];

          void addMarker(Offset? orig, Color color, String label, void Function(Offset) onDrag) {
            if (orig == null) return;
            final pos = ctrl.toPreview(orig, size);
            // 시각 (IgnorePointer)
            children.add(Positioned(
              left: pos.dx - 60,
              top: pos.dy - 56,
              child: IgnorePointer(
                child: SizedBox(
                  width: 120,
                  height: 64,
                  child: _MarkerVisual(color: color, label: label),
                ),
              ),
            ));
            // 드래그 핫스팟 (점 위)
            children.add(Positioned(
              left: pos.dx - 16,
              top: pos.dy - 16,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (d) => onDrag(d.delta / scale),
                child: const SizedBox(width: 32, height: 32),
              ),
            ));
          }

          if (ctrl.isHole) {
            addMarker(ctrl.holeLip.value, _kAmber, '입구', (delta) => ctrl.moveHoleLip(delta));
            addMarker(ctrl.tapeReading.value, _kBlue, '읽기', (delta) => ctrl.moveTape(delta));
          } else {
            addMarker(ctrl.startPoint.value, _kBlue, '시작', (delta) => ctrl.moveStart(delta));
            addMarker(ctrl.endPoint.value, _kRed, '끝', (delta) => ctrl.moveEnd(delta));
          }

          return Stack(children: children);
        });
      }),
    );
  }

  Widget _hintCard(AnnotateController ctrl) {
    return Obx(() {
      String text;
      if (!ctrl.isHole) {
        text = '마커를 드래그해 시작·끝점을 정밀하게 맞추세요. 사진 빈 곳을 탭하면 가까운 점이 이동합니다.';
      } else {
        switch (ctrl.currentStep) {
          case 1:
            text = '1단계. 홀 입구 기준점을 터치하세요.';
            break;
          case 2:
            text = '2단계. 줄자 숫자를 읽는 위치를 터치하세요.';
            break;
          case 3:
            text = '3단계. 시작점(줄자 끝) 가시성을 선택하세요.';
            break;
          default:
            text = '4단계. 줄자 끝이 바닥에 닿았는지 선택하세요.';
        }
      }
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: ctrl.isHole ? _kAmber : _kBlue, width: 4)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4)),
      );
    });
  }

  Widget _holeRadios(AnnotateController ctrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RadioRow(
            label: '시작점 가시성',
            options: const {'visible': '보임', 'hidden_behind_lip': '입구에 가림'},
            valueRx: ctrl.startVisibility,
          ),
          const SizedBox(height: 8),
          _RadioRow(
            label: '줄자 끝 접촉',
            options: const {'yes': '닿음', 'no': '안 닿음', 'unknown': '모름'},
            valueRx: ctrl.contactConfirm,
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(AnnotateController ctrl) {
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

class _MarkerVisual extends StatelessWidget {
  final Color color;
  final String label;
  const _MarkerVisual({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 라벨 pill (상단)
        Positioned(
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 3)],
            ),
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ),
        // stem (점선 대신 얇은 선)
        Positioned(
          top: 24,
          child: Container(width: 2, height: 24, color: color),
        ),
        // 측정 지점 (하단 중앙)
        Positioned(
          top: 48,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 4),
            ),
          ),
        ),
      ],
    );
  }
}

class _RadioRow extends StatelessWidget {
  final String label;
  final Map<String, String> options;
  final Rxn<String> valueRx;
  const _RadioRow({required this.label, required this.options, required this.valueRx});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 96,
          child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kInk)),
        ),
        Expanded(
          child: Obx(() => Wrap(
                spacing: 8,
                children: options.entries.map((e) {
                  final selected = valueRx.value == e.key;
                  return GestureDetector(
                    onTap: () => valueRx.value = e.key,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.blue50 : Colors.white,
                        border: Border.all(color: selected ? _kBlue : const Color(0xFFD1D5DB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        e.value,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? _kBlue : const Color(0xFF374151),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
        ),
      ],
    );
  }
}
