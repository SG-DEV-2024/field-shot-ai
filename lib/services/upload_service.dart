import 'dart:io';
import 'package:dio/dio.dart';

// Mock 업로드 서비스 - httpbin.org/post 사용 (실제 서버 연동 전 테스트용)
class UploadService {
  UploadService._();
  static final I = UploadService._();

  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // 단건 업로드 (사진 + 메타데이터)
  Future<bool> uploadRecord({
    required String id,
    required String photoPath,
    required double value,
    required String surveyType,
    required String note,
    required DateTime timestamp,
  }) async {
    // 1초 딜레이 (실제 업로드 시뮬레이션)
    await Future.delayed(const Duration(seconds: 1));

    try {
      final file = File(photoPath);
      if (!await file.exists()) return false;

      final formData = FormData.fromMap({
        'id': id,
        'surveyType': surveyType,
        'value': value.toString(),
        'note': note,
        'timestamp': timestamp.toIso8601String(),
        'photo': await MultipartFile.fromFile(photoPath, filename: '$id.jpg'),
      });

      final response = await _dio.post(
        'https://httpbin.org/post',
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 일괄 업로드
  Future<Map<String, bool>> uploadBatch(List<Map<String, dynamic>> records) async {
    final results = <String, bool>{};
    for (final record in records) {
      final success = await uploadRecord(
        id: record['id'],
        photoPath: record['photoPath'],
        value: record['value'],
        surveyType: record['surveyType'],
        note: record['note'],
        timestamp: record['timestamp'],
      );
      results[record['id']] = success;
    }
    return results;
  }
}
