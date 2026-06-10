import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ai_camera/models/survey_record.dart';

/// 실서버 업로드 서비스 — POST /api/shot-survey/records (multipart/form-data).
/// SurveyRecord 단위로 업로드, 규격조사는 annotation_json(flat) 동봉.
///
/// 전송 필드: image_file, id, survey_type, subtype, measured_value, note,
/// captured_at, annotation_json, image_width, image_height, app_version, os_version.
/// (worker_id는 서버 허용이지만 요청에 따라 미전송.)
class UploadService {
  UploadService._();
  static final I = UploadService._();

  static const String _serverUrl =
      'https://api.oasisd.co.kr/api/shot-survey/records';

  /// 서버 인증 키 (헤더 `x-api-key`). 서버 담당자 발급.
  /// 주의: APK에 그대로 포함됨 — 노출되면 안 되는 값이면 별도 설정으로 분리 필요.
  static const String _apiKey = 'e3a0afa63ed8442883c5a48cebfe8244';

  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'x-api-key': _apiKey},
  ));

  String? _appVersion;
  String? _osVersion;

  /// 앱/OS 버전을 최초 1회 조회 후 캐시. 실패해도 'unknown'으로 진행(업로드는 막지 않음).
  Future<void> _ensureMeta() async {
    if (_appVersion != null) return;
    try {
      final info = await PackageInfo.fromPlatform();
      _appVersion = info.version; // 예: "1.0.2"
    } catch (_) {
      _appVersion = 'unknown';
    }
    try {
      final dip = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final a = await dip.androidInfo;
        _osVersion = 'Android ${a.version.release} (SDK ${a.version.sdkInt})';
      } else if (Platform.isIOS) {
        final i = await dip.iosInfo;
        _osVersion = '${i.systemName} ${i.systemVersion}';
      } else {
        _osVersion = Platform.operatingSystem;
      }
    } catch (_) {
      _osVersion = 'unknown';
    }
  }

  /// 단건 업로드 (사진 파일 + 메타데이터 + 규격조사 annotation_json).
  /// 성공 시 true. 파일 없음 / 네트워크 오류 / 서버 거부 시 false (사유는 로그 출력).
  Future<bool> uploadRecord(SurveyRecord r) async {
    try {
      final file = File(r.photoPath);
      if (!await file.exists()) {
        _log('파일 없음 → 업로드 중단 id=${r.id} path=${r.photoPath}');
        return false;
      }

      await _ensureMeta();

      // 원본 픽셀 크기: 규격조사는 annotation 메타에 이미 있음.
      // 없으면(탄산화 등) 파일을 직접 디코드해서 실제 크기를 읽는다.
      int imgW = r.annotation?.imageWidth ?? 0;
      int imgH = r.annotation?.imageHeight ?? 0;
      if (imgW <= 0 || imgH <= 0) {
        final size = await _readImageSize(file);
        if (size != null) {
          imgW = size.$1;
          imgH = size.$2;
        }
      }

      // 규격조사 좌표·수치 메타는 toJson() flat 그대로 (null 키 제거).
      // 탄산화는 annotation 없음 → 빈 문자열.
      String annotationJson = '';
      if (r.annotation != null) {
        final m = r.annotation!.toJson()..removeWhere((_, v) => v == null);
        annotationJson = jsonEncode(m);
      }

      final fields = <String, dynamic>{
        'id': r.id,
        'survey_type': r.surveyType.code,
        'subtype': r.measurementSubtype?.code ?? '',
        'measured_value': _fmtValue(r.value),
        'note': r.note,
        'captured_at': _iso8601WithOffset(r.timestamp),
        'annotation_json': annotationJson,
        'image_width': imgW.toString(),
        'image_height': imgH.toString(),
        'app_version': _appVersion ?? 'unknown',
        'os_version': _osVersion ?? 'unknown',
      };

      _log('업로드 시작 id=${r.id} type=${r.surveyType.code} '
          'subtype=${fields['subtype']} value=${fields['measured_value']} '
          'img=${imgW}x$imgH ann=${annotationJson.isEmpty ? 'none' : '${annotationJson.length}B'} '
          'app=$_appVersion os=$_osVersion → $_serverUrl');

      final form = FormData.fromMap({
        ...fields,
        'image_file':
            await MultipartFile.fromFile(r.photoPath, filename: '${r.id}.jpg'),
      });

      final res = await _dio.post(_serverUrl, data: form);
      final body = res.data;

      // 서버가 HTTP 200 + 바디로 결과를 줄 수 있음: {"status":200,...} 성공 / {"status":400,...} 실패.
      if (body is Map) {
        final status = body['status'];
        if (status != null && status != 200 && status != '200') {
          final ok = body['success'] == true;
          _log('서버 응답 거부 id=${r.id} status=$status msg=${body['msg']} → ok=$ok');
          return ok;
        }
      }
      if (res.statusCode != 200) {
        _log('업로드 실패 id=${r.id} HTTP=${res.statusCode} body=$body');
        return false;
      }
      _log('업로드 성공 id=${r.id} HTTP=${res.statusCode} body=$body');
      return true;
    } on DioException catch (e) {
      // 서버가 4xx/5xx로 거부하면 여기로 옴. 응답 본문(status/msg)을 그대로 출력.
      _log(
        '업로드 오류(Dio) id=${r.id} type=${e.type} '
        'HTTP=${e.response?.statusCode} body=${e.response?.data} msg=${e.message}',
        e,
      );
      return false;
    } catch (e, st) {
      _log('업로드 오류(예외) id=${r.id}: $e', e, st);
      return false;
    }
  }

  void _log(String message, [Object? error, StackTrace? stackTrace]) {
    final b = StringBuffer('[UploadService] $message');
    if (error != null) b.write(' | error: $error');
    if (stackTrace != null) b.write('\n$stackTrace');
    debugPrint(b.toString());
  }

  /// 정수면 소수점 제거("300"), 소수면 그대로("12.5").
  String _fmtValue(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  /// ISO 8601 + 타임존 오프셋: "2026-05-28T14:32:00+09:00".
  /// DateTime.toIso8601String()은 로컬에서 오프셋을 안 붙이므로 직접 구성.
  String _iso8601WithOffset(DateTime dt) {
    final d = dt.toLocal();
    final base = d.toIso8601String().split('.').first; // 밀리초 제거
    final off = d.timeZoneOffset;
    final sign = off.isNegative ? '-' : '+';
    final hh = off.inHours.abs().toString().padLeft(2, '0');
    final mm = (off.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return '$base$sign$hh:$mm';
  }

  /// JPEG 등 이미지 파일을 디코드해 원본 픽셀 크기 (width, height) 반환. 실패 시 null.
  Future<(int, int)?> _readImageSize(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final w = frame.image.width;
      final h = frame.image.height;
      frame.image.dispose();
      return (w, h);
    } catch (_) {
      return null;
    }
  }
}
