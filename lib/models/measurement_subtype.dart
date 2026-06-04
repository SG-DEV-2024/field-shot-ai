/// 규격조사(dimension) 하위 측정 유형.
/// 탄산화(carbonation) 레코드는 subtype 없음(null).
enum MeasurementSubtype {
  wallOrMemberWidth('wall_or_member_width', '벽체/기둥/슬라브 폭 측정'),
  memberGap('member_gap', '부재 규격 조사'),
  holeDepth('hole_depth', '홀 깊이 측정');

  const MeasurementSubtype(this.code, this.label);

  /// 서버 전송 / JSON 저장용 코드 (snake_case)
  final String code;

  /// UI 표시용 라벨
  final String label;

  /// 칩/배지용 짧은 라벨
  String get shortLabel {
    switch (this) {
      case MeasurementSubtype.wallOrMemberWidth:
        return '폭';
      case MeasurementSubtype.memberGap:
        return '간격';
      case MeasurementSubtype.holeDepth:
        return '홀 깊이';
    }
  }

  /// 카메라/입력 화면 상단 안내 문구
  String get cameraHint {
    switch (this) {
      case MeasurementSubtype.wallOrMemberWidth:
        return '측정 시작면과 끝면이 모두 보이게 촬영하세요.';
      case MeasurementSubtype.memberGap:
        return '시작과 끝의 단면이 모두 포함되게 촬영하세요.';
      case MeasurementSubtype.holeDepth:
        return '홀 입구와 줄자 숫자가 함께 보이게 촬영하세요.';
    }
  }

  /// 한 줄 설명 (S-002 카드 부제)
  String get description {
    switch (this) {
      case MeasurementSubtype.wallOrMemberWidth:
        return '줄자 0을 측정 시작면에 맞춰 폭 측정';
      case MeasurementSubtype.memberGap:
        return '줄자 임의 눈금에서 시작해 간격 측정';
      case MeasurementSubtype.holeDepth:
        return '홀 입구에서 보이는 줄자 숫자로 깊이 측정';
    }
  }

  static MeasurementSubtype? fromCode(String? code) {
    if (code == null) return null;
    for (final s in MeasurementSubtype.values) {
      if (s.code == code) return s;
    }
    return null;
  }
}
