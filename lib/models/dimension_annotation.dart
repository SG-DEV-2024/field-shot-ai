/// 규격조사(dimension) 레코드의 측정 좌표·수치·속성 메타.
/// 탄산화 레코드에는 존재하지 않음(null).
///
/// 좌표는 모두 "원본 이미지 픽셀" 기준 (좌상단 [0,0]).
/// preview(터치) 좌표 → 원본 픽셀 변환은 AnnotateController.toOriginalPixel 참조.
class DimensionAnnotation {
  // ----- 측정점 좌표 (원본 픽셀, [x, y]) -----
  final List<double>? startPointPixel; // 폭/간격: 시작점
  final List<double>? endPointPixel; // 폭/간격: 끝점
  final List<double>? holeLipPixel; // 홀 깊이: 홀 입구 기준점
  final List<double>? tapeReadingPixel; // 홀 깊이: 줄자 읽기 위치

  // ----- 수치 (mm) -----
  final double? startValue; // 폭/간격: 줄자 시작값
  final double? endValue; // 폭/간격: 줄자 끝값
  final double? visibleReadingValue; // 홀 깊이: 보이는 줄자 숫자
  final double measuredValue; // 계산 결과 (mm)

  // ----- 속성 -----
  final String? startSurfaceType; // wall_edge | column_edge | beam_edge | slab_edge | other
  final String? endSurfaceType;
  final String tapeDirection; // horizontal | vertical
  final String? startVisibility; // visible | hidden_behind_lip (홀 깊이)
  final String? contactConfirmation; // yes | no | unknown (홀 깊이)

  // ----- 품질 플래그 (현장 입력 단계에선 보통 null, 후처리 큐레이션에서 채움) -----
  final QualityFlags? qualityFlags;

  // ----- 원본 이미지 크기 (좌표 환산용 메타) -----
  final int imageWidth;
  final int imageHeight;

  DimensionAnnotation({
    this.startPointPixel,
    this.endPointPixel,
    this.holeLipPixel,
    this.tapeReadingPixel,
    this.startValue,
    this.endValue,
    this.visibleReadingValue,
    required this.measuredValue,
    this.startSurfaceType,
    this.endSurfaceType,
    this.tapeDirection = 'horizontal',
    this.startVisibility,
    this.contactConfirmation,
    this.qualityFlags,
    required this.imageWidth,
    required this.imageHeight,
  });

  DimensionAnnotation copyWith({
    double? startValue,
    double? endValue,
    double? visibleReadingValue,
    double? measuredValue,
  }) {
    return DimensionAnnotation(
      startPointPixel: startPointPixel,
      endPointPixel: endPointPixel,
      holeLipPixel: holeLipPixel,
      tapeReadingPixel: tapeReadingPixel,
      startValue: startValue ?? this.startValue,
      endValue: endValue ?? this.endValue,
      visibleReadingValue: visibleReadingValue ?? this.visibleReadingValue,
      measuredValue: measuredValue ?? this.measuredValue,
      startSurfaceType: startSurfaceType,
      endSurfaceType: endSurfaceType,
      tapeDirection: tapeDirection,
      startVisibility: startVisibility,
      contactConfirmation: contactConfirmation,
      qualityFlags: qualityFlags,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
    );
  }

  Map<String, dynamic> toJson() => {
        'startPointPixel': startPointPixel,
        'endPointPixel': endPointPixel,
        'holeLipPixel': holeLipPixel,
        'tapeReadingPixel': tapeReadingPixel,
        'startValue': startValue,
        'endValue': endValue,
        'visibleReadingValue': visibleReadingValue,
        'measuredValue': measuredValue,
        'startSurfaceType': startSurfaceType,
        'endSurfaceType': endSurfaceType,
        'tapeDirection': tapeDirection,
        'startVisibility': startVisibility,
        'contactConfirmation': contactConfirmation,
        'qualityFlags': qualityFlags?.toJson(),
        'imageWidth': imageWidth,
        'imageHeight': imageHeight,
      };

  factory DimensionAnnotation.fromJson(Map<String, dynamic> j) => DimensionAnnotation(
        startPointPixel: _toDoubleList(j['startPointPixel']),
        endPointPixel: _toDoubleList(j['endPointPixel']),
        holeLipPixel: _toDoubleList(j['holeLipPixel']),
        tapeReadingPixel: _toDoubleList(j['tapeReadingPixel']),
        startValue: _toDouble(j['startValue']),
        endValue: _toDouble(j['endValue']),
        visibleReadingValue: _toDouble(j['visibleReadingValue']),
        measuredValue: _toDouble(j['measuredValue']) ?? 0,
        startSurfaceType: j['startSurfaceType'],
        endSurfaceType: j['endSurfaceType'],
        tapeDirection: j['tapeDirection'] ?? 'horizontal',
        startVisibility: j['startVisibility'],
        contactConfirmation: j['contactConfirmation'],
        qualityFlags: j['qualityFlags'] == null
            ? null
            : QualityFlags.fromJson(j['qualityFlags'] as Map<String, dynamic>),
        imageWidth: (j['imageWidth'] as num?)?.toInt() ?? 0,
        imageHeight: (j['imageHeight'] as num?)?.toInt() ?? 0,
      );

  static List<double>? _toDoubleList(dynamic v) {
    if (v == null) return null;
    return (v as List).map((e) => (e as num).toDouble()).toList();
  }

  static double? _toDouble(dynamic v) => v == null ? null : (v as num).toDouble();
}

/// 학습 품질 플래그 (후처리 큐레이션 단계에서 채움)
class QualityFlags {
  final bool digitsClear;
  final bool startEdgeVisible;
  final bool endEdgeVisible;
  final bool tapeStraight;
  final String perspectiveDistortion; // low | medium | high
  final bool occlusion;

  QualityFlags({
    this.digitsClear = false,
    this.startEdgeVisible = false,
    this.endEdgeVisible = false,
    this.tapeStraight = false,
    this.perspectiveDistortion = 'low',
    this.occlusion = false,
  });

  Map<String, dynamic> toJson() => {
        'digitsClear': digitsClear,
        'startEdgeVisible': startEdgeVisible,
        'endEdgeVisible': endEdgeVisible,
        'tapeStraight': tapeStraight,
        'perspectiveDistortion': perspectiveDistortion,
        'occlusion': occlusion,
      };

  factory QualityFlags.fromJson(Map<String, dynamic> j) => QualityFlags(
        digitsClear: j['digitsClear'] ?? false,
        startEdgeVisible: j['startEdgeVisible'] ?? false,
        endEdgeVisible: j['endEdgeVisible'] ?? false,
        tapeStraight: j['tapeStraight'] ?? false,
        perspectiveDistortion: j['perspectiveDistortion'] ?? 'low',
        occlusion: j['occlusion'] ?? false,
      );
}
