enum UploadStatus { pending, uploaded }

enum SurveyType {
  carbonation('탄산화 조사'),
  rebarSpacing('배근 간격 조사');

  const SurveyType(this.label);
  final String label;
}

class SurveyRecord {
  final String id;
  final SurveyType surveyType;
  final String photoPath;
  final double value;
  final String note;
  final DateTime timestamp;
  UploadStatus uploadStatus;

  SurveyRecord({
    required this.id,
    required this.surveyType,
    required this.photoPath,
    required this.value,
    required this.note,
    required this.timestamp,
    this.uploadStatus = UploadStatus.pending,
  });

  SurveyRecord copyWith({double? value, String? note, UploadStatus? uploadStatus}) {
    return SurveyRecord(
      id: id,
      surveyType: surveyType,
      photoPath: photoPath,
      value: value ?? this.value,
      note: note ?? this.note,
      timestamp: timestamp,
      uploadStatus: uploadStatus ?? this.uploadStatus,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surveyType': surveyType.name,
        'photoPath': photoPath,
        'value': value,
        'note': note,
        'timestamp': timestamp.toIso8601String(),
        'uploadStatus': uploadStatus.name,
      };

  factory SurveyRecord.fromJson(Map<String, dynamic> json) => SurveyRecord(
        id: json['id'],
        surveyType: SurveyType.values.firstWhere((e) => e.name == json['surveyType']),
        photoPath: json['photoPath'],
        value: (json['value'] as num).toDouble(),
        note: json['note'] ?? '',
        timestamp: DateTime.parse(json['timestamp']),
        uploadStatus: UploadStatus.values.firstWhere((e) => e.name == json['uploadStatus']),
      );
}
