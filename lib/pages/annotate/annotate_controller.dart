import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/models/measurement_subtype.dart';
import 'package:ai_camera/routes/app_pages.dart';

/// S-004(폭/간격) / S-007(홀 깊이) 측정점 지정.
/// 좌표는 원본 이미지 픽셀 기준으로 보관, UI는 preview로 환산.
class AnnotateController extends GetxController {
  static AnnotateController get I => Get.find();

  late String photoPath;
  late SurveyType surveyType;
  MeasurementSubtype? subtype;
  late int imageWidth;
  late int imageHeight;

  // 측정점 (원본 픽셀)
  final startPoint = Rxn<Offset>(); // 폭/간격 시작
  final endPoint = Rxn<Offset>(); // 폭/간격 끝
  final holeLip = Rxn<Offset>(); // 홀 입구
  final tapeReading = Rxn<Offset>(); // 줄자 읽기 위치

  // 라벨 위치 (원본 픽셀) — 측정 지점과 분리되어 자유 드래그. stem(점선)으로 연결.
  // point 드래그 = 라벨 동반(오프셋 유지) / label 드래그 = 라벨만 이동(줄자 영역 가림 회피).
  final startLabel = Rxn<Offset>();
  final endLabel = Rxn<Offset>();
  final holeLipLabel = Rxn<Offset>();
  final tapeReadingLabel = Rxn<Offset>();

  // 직전 탭/드래그로 활성화된 마커 — 생성 직후 같은 드래그 제스처로 이어서 끌기 위함.
  Rxn<Offset>? _activePoint;
  Rxn<Offset>? _activeLabel;

  // 홀 깊이 부속 입력
  final startVisibility = Rxn<String>(); // visible | hidden_behind_lip
  final contactConfirm = Rxn<String>(); // yes | no | unknown

  bool get isHole => subtype == MeasurementSubtype.holeDepth;

  Size get originalSize => Size(imageWidth.toDouble(), imageHeight.toDouble());

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    photoPath = args?['photoPath'] ?? '';
    surveyType = args?['surveyType'] ?? SurveyType.dimension;
    subtype = args?['subtype'] as MeasurementSubtype?;
    imageWidth = args?['imageWidth'] ?? 0;
    imageHeight = args?['imageHeight'] ?? 0;

    // 이미지 크기를 못 읽었을 때 안전한 기본값
    if (imageWidth <= 0 || imageHeight <= 0) {
      imageWidth = 1440;
      imageHeight = 1080;
    }

    if (!isHole) {
      final ps = args?['prefilledStart'] as List<double>?;
      final pe = args?['prefilledEnd'] as List<double>?;
      startPoint.value = ps != null ? Offset(ps[0], ps[1]) : Offset(imageWidth * 0.3, imageHeight / 2);
      endPoint.value = pe != null ? Offset(pe[0], pe[1]) : Offset(imageWidth * 0.7, imageHeight / 2);
      // 라벨은 측정 지점 위쪽 대각(시작=좌상 / 끝=우상)에 초기 배치 → stem 대각선.
      startLabel.value = _autoLabel(startPoint.value!, dx: -imageWidth * 0.05);
      endLabel.value = _autoLabel(endPoint.value!, dx: imageWidth * 0.05);
    }
  }

  /// 라벨 초기 위치 — 측정 지점 기준 위쪽(점이 사진 상단이면 아래쪽), x는 dx만큼 비낌.
  /// vFrac = 점↔라벨 세로 간격(이미지 높이 대비). 홀 깊이는 절반(0.10)으로 호출.
  Offset _autoLabel(Offset point, {double dx = 0, double vFrac = 0.20}) {
    final h = imageHeight.toDouble();
    final dy = point.dy > h * 0.22 ? -h * vFrac : h * vFrac;
    return _clamp(Offset(point.dx + dx, point.dy + dy));
  }

  // ---------- 좌표 변환 (BoxFit.contain) ----------
  /// 원본 픽셀 → preview 좌표
  Offset toPreview(Offset orig, Size previewSize) {
    final scale = math.max(previewSize.width / imageWidth, previewSize.height / imageHeight);
    final renderedW = imageWidth * scale;
    final renderedH = imageHeight * scale;
    final offsetX = (previewSize.width - renderedW) / 2;
    final offsetY = (previewSize.height - renderedH) / 2;
    return Offset(offsetX + orig.dx * scale, offsetY + orig.dy * scale);
  }

  /// preview 좌표 → 원본 픽셀
  Offset toOriginal(Offset preview, Size previewSize) {
    final scale = math.max(previewSize.width / imageWidth, previewSize.height / imageHeight);
    final renderedW = imageWidth * scale;
    final renderedH = imageHeight * scale;
    final offsetX = (previewSize.width - renderedW) / 2;
    final offsetY = (previewSize.height - renderedH) / 2;
    final x = ((preview.dx - offsetX) / scale).clamp(0.0, imageWidth.toDouble());
    final y = ((preview.dy - offsetY) / scale).clamp(0.0, imageHeight.toDouble());
    return Offset(x, y);
  }

  /// preview 델타 → 원본 델타 변환용 scale
  double scaleFor(Size previewSize) =>
      math.max(previewSize.width / imageWidth, previewSize.height / imageHeight);

  // ---------- 측정 지점(point) 드래그 — 라벨도 같은 변위로 동반 이동 ----------
  void moveStart(Offset d) => _movePair(startPoint, startLabel, d);
  void moveEnd(Offset d) => _movePair(endPoint, endLabel, d);
  void moveHoleLip(Offset d) => _movePair(holeLip, holeLipLabel, d);
  void moveTape(Offset d) => _movePair(tapeReading, tapeReadingLabel, d);

  void _movePair(Rxn<Offset> point, Rxn<Offset> label, Offset d) {
    if (point.value == null) return;
    point.value = _clamp(point.value! + d);
    if (label.value != null) label.value = _clamp(label.value! + d);
  }

  // ---------- 라벨(label) 자유 드래그 — point는 그대로, 라벨만 이동 ----------
  void moveStartLabel(Offset d) => _moveLabel(startLabel, startPoint, d);
  void moveEndLabel(Offset d) => _moveLabel(endLabel, endPoint, d);
  void moveHoleLipLabel(Offset d) => _moveLabel(holeLipLabel, holeLip, d);
  void moveTapeLabel(Offset d) => _moveLabel(tapeReadingLabel, tapeReading, d);

  void _moveLabel(Rxn<Offset> label, Rxn<Offset> point, Offset d) {
    final base = label.value ?? point.value;
    if (base == null) return;
    label.value = _clamp(base + d);
  }

  Offset _clamp(Offset o) => Offset(
        o.dx.clamp(0.0, imageWidth.toDouble()),
        o.dy.clamp(0.0, imageHeight.toDouble()),
      );

  /// 홀 깊이: 사진 빈 곳 탭 → 다음 단계 점 배치, 둘 다 있으면 가까운 점 이동.
  void tapPlace(Offset original) {
    if (!isHole) {
      // 폭/간격: 가까운 점을 이동 (라벨 동반)
      _moveNearestPair(original, [
        [startPoint, startLabel],
        [endPoint, endLabel],
      ]);
      return;
    }
    if (holeLip.value == null) {
      holeLip.value = original;
      holeLipLabel.value = _autoLabel(original, vFrac: 0.10);
      _setActive(holeLip, holeLipLabel);
    } else if (tapeReading.value == null) {
      tapeReading.value = original;
      tapeReadingLabel.value = _autoLabel(original, vFrac: 0.10);
      _setActive(tapeReading, tapeReadingLabel);
    } else {
      _moveNearestPair(original, [
        [holeLip, holeLipLabel],
        [tapeReading, tapeReadingLabel],
      ]);
    }
  }

  void _setActive(Rxn<Offset> point, Rxn<Offset> label) {
    _activePoint = point;
    _activeLabel = label;
  }

  /// 생성·선택 직후 같은 제스처로 측정점을 절대 위치로 이어 끌기 (라벨 동반).
  void dragActiveTo(Offset original) {
    final p = _activePoint, l = _activeLabel;
    if (p == null || p.value == null) return;
    final np = _clamp(original);
    final delta = np - p.value!;
    if (l != null && l.value != null) l.value = _clamp(l.value! + delta);
    p.value = np;
  }

  /// 가까운 측정 지점을 target으로 이동 (라벨도 같은 변위로 동반).
  void _moveNearestPair(Offset target, List<List<Rxn<Offset>>> pairs) {
    List<Rxn<Offset>>? nearest;
    double best = double.infinity;
    for (final pair in pairs) {
      final p = pair[0];
      if (p.value == null) continue;
      final d = (p.value! - target).distance;
      if (d < best) {
        best = d;
        nearest = pair;
      }
    }
    if (nearest == null) return;
    final point = nearest[0], label = nearest[1];
    final delta = target - point.value!;
    point.value = _clamp(target);
    if (label.value != null) label.value = _clamp(label.value! + delta);
    _setActive(point, label);
  }

  // ---------- 현재 단계 (홀 깊이 진행 표시) ----------
  int get currentStep {
    if (!isHole) return startPoint.value != null && endPoint.value != null ? 2 : 1;
    if (holeLip.value == null) return 1;
    if (tapeReading.value == null) return 2;
    if (startVisibility.value == null) return 3;
    if (contactConfirm.value == null) return 4;
    return 4;
  }

  bool get isValid {
    if (!isHole) {
      if (startPoint.value == null || endPoint.value == null) return false;
      return (startPoint.value! - endPoint.value!).distance >= 5;
    }
    return holeLip.value != null &&
        tapeReading.value != null &&
        startVisibility.value != null &&
        contactConfirm.value != null;
  }

  void next() {
    if (!isValid) return;
    final partial = <String, dynamic>{
      'photoPath': photoPath,
      'surveyType': surveyType,
      'subtype': subtype,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'startPointPixel': startPoint.value == null ? null : [startPoint.value!.dx, startPoint.value!.dy],
      'endPointPixel': endPoint.value == null ? null : [endPoint.value!.dx, endPoint.value!.dy],
      'holeLipPixel': holeLip.value == null ? null : [holeLip.value!.dx, holeLip.value!.dy],
      'tapeReadingPixel': tapeReading.value == null ? null : [tapeReading.value!.dx, tapeReading.value!.dy],
      'startVisibility': startVisibility.value,
      'contactConfirm': contactConfirm.value,
    };
    Get.toNamed(AppRoutes.dimensionInput, arguments: partial);
  }

  void retake() {
    try {
      File(photoPath).deleteSync();
    } catch (_) {}
    Get.back(); // 카메라로 복귀
  }
}
