import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ai_camera/models/survey_record.dart';

/// Mock 업로드 서비스 - httpbin.org/post (실제 서버 연동 전 테스트용).
/// v2: SurveyRecord 단위로 업로드, 규격조사는 annotation_json 동봉.
class UploadService {
  UploadService._();
  static final I = UploadService._();

  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static const String _serverUrl = 'https://httpbin.org/post'; // TODO: 실제 서버 엔드포인트
  static const String _appVersion = '1.0.1';

  String get _deviceId => 'device-unknown'; // TODO: device_info_plus 등으로 실제 ID
  String get _osVersion {
    try {
      return '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    } catch (_) {
      return 'unknown';
    }
  }

  /// 단건 업로드 (사진 + 메타데이터 + 규격조사 annotation_json).
  Future<bool> uploadRecord(SurveyRecord r) async {
    await Future.delayed(const Duration(seconds: 1)); // 업로드 시뮬레이션

    try {
      final file = File(r.photoPath);
      if (!await file.exists()) return false;

      final map = <String, dynamic>{
        'id': r.id,
        'survey_type': r.surveyType.code,
        'value': r.value.toString(),
        'note': r.note,
        'captured_at': r.timestamp.toIso8601String(),
        'image_file': await MultipartFile.fromFile(r.photoPath, filename: '${r.id}.jpg'),
        'worker_id': _deviceId,
        'app_version': _appVersion,
        'os_version': _osVersion,
      };

      if (r.measurementSubtype != null) {
        map['subtype'] = r.measurementSubtype!.code;
      }

      // 규격조사: annotation_json 동봉 (탄산화는 null → 미동봉, 서버 무시)
      if (r.annotation != null) {
        map['annotation_json'] = jsonEncode({
          'schema_version': '1.0',
          'survey_type': r.surveyType.code,
          'measurement_subtype': r.measurementSubtype?.code,
          'device_id': _deviceId,
          'captured_at': r.timestamp.toIso8601String(),
          'image': {
            'file_name': '${r.id}.jpg',
            'width': r.annotation!.imageWidth,
            'height': r.annotation!.imageHeight,
            'mime_type': 'image/jpeg',
          },
          'unit': 'mm',
          'annotation': r.annotation!.toJson(),
        });
      }

      final response = await _dio.post(_serverUrl, data: FormData.fromMap(map));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
