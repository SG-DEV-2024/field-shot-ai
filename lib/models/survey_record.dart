import 'package:ai_camera/models/measurement_subtype.dart';
import 'package:ai_camera/models/dimension_annotation.dart';

enum UploadStatus { pending, uploaded }

enum SurveyType {
  carbonation('탄산화 조사', 'carbonation'),
  dimension('규격 조사', 'dimension');

  const SurveyType(this.label, this.code);
  final String label;

  /// 서버 전송 / JSON 저장용 코드
  final String code;

  /// JSON 문자열 → SurveyType.
  /// v1의 `rebarSpacing`은 v2에서 `dimension`으로 흡수(마이그레이션).
  static SurveyType fromCode(String? code) {
    if (code == null) return SurveyType.carbonation;
    if (code == 'rebarSpacing' || code == 'rebar_spacing') return SurveyType.dimension;
    for (final t in SurveyType.values) {
      if (t.code == code || t.name == code) return t;
    }
    return SurveyType.carbonation;
  }
}

class SurveyRecord {
  final String id;
  final SurveyType surveyType;
  final MeasurementSubtype? measurementSubtype; // 규격조사만, 탄산화는 null
  final String photoPath;
  final double value; // 호환용: measured_value 결과
  final DimensionAnnotation? annotation; // 규격조사만
  final String note;
  final DateTime timestamp;
  UploadStatus uploadStatus;

  SurveyRecord({
    required this.id,
    required this.surveyType,
    this.measurementSubtype,
    required this.photoPath,
    required this.value,
    this.annotation,
    required this.note,
    required this.timestamp,
    this.uploadStatus = UploadStatus.pending,
  });

  SurveyRecord copyWith({
    double? value,
    String? note,
    UploadStatus? uploadStatus,
    DimensionAnnotation? annotation,
  }) {
    return SurveyRecord(
      id: id,
      surveyType: surveyType,
      measurementSubtype: measurementSubtype,
      photoPath: photoPath,
      value: value ?? this.value,
      annotation: annotation ?? this.annotation,
      note: note ?? this.note,
      timestamp: timestamp,
      uploadStatus: uploadStatus ?? this.uploadStatus,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surveyType': surveyType.code,
        'measurementSubtype': measurementSubtype?.code,
        'photoPath': photoPath,
        'value': value,
        'annotation': annotation?.toJson(),
        'note': note,
        'timestamp': timestamp.toIso8601String(),
        'uploadStatus': uploadStatus.name,
      };

  factory SurveyRecord.fromJson(Map<String, dynamic> json) => SurveyRecord(
        id: json['id'],
        surveyType: SurveyType.fromCode(json['surveyType']),
        measurementSubtype: MeasurementSubtype.fromCode(json['measurementSubtype']),
        photoPath: json['photoPath'],
        value: (json['value'] as num).toDouble(),
        annotation: json['annotation'] == null
            ? null
            : DimensionAnnotation.fromJson(json['annotation'] as Map<String, dynamic>),
        note: json['note'] ?? '',
        timestamp: DateTime.parse(json['timestamp']),
        uploadStatus: UploadStatus.values.firstWhere(
          (e) => e.name == json['uploadStatus'],
          orElse: () => UploadStatus.pending,
        ),
      );
}
