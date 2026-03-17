import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:ai_camera/models/survey_record.dart';

class StorageService {
  StorageService._();
  static final I = StorageService._();

  late Directory _captureDir;
  final List<SurveyRecord> _records = [];

  List<SurveyRecord> get records => List.unmodifiable(_records);

  List<SurveyRecord> get todayRecords {
    final today = DateTime.now();
    return _records.where((r) {
      return r.timestamp.year == today.year &&
          r.timestamp.month == today.month &&
          r.timestamp.day == today.day;
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  int get totalToday => todayRecords.length;
  int get pendingCount => todayRecords.where((r) => r.uploadStatus == UploadStatus.pending).length;
  int get uploadedCount => todayRecords.where((r) => r.uploadStatus == UploadStatus.uploaded).length;

  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    _captureDir = Directory('${appDir.path}/capture');
    if (!await _captureDir.exists()) await _captureDir.create(recursive: true);
    await _load();
  }

  Future<void> _load() async {
    final file = File('${_captureDir.path}/records.json');
    if (!await file.exists()) return;
    final content = await file.readAsString();
    final list = jsonDecode(content) as List;
    _records.clear();
    _records.addAll(list.map((e) => SurveyRecord.fromJson(e)));
  }

  Future<void> _save() async {
    final file = File('${_captureDir.path}/records.json');
    await file.writeAsString(jsonEncode(_records.map((e) => e.toJson()).toList()));
  }

  Future<String> getPhotoDir() async {
    final dir = Directory('${_captureDir.path}/photos');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }

  Future<void> addRecord(SurveyRecord record) async {
    _records.add(record);
    await _save();
  }

  Future<void> updateRecord(SurveyRecord updated) async {
    final idx = _records.indexWhere((r) => r.id == updated.id);
    if (idx == -1) return;
    _records[idx] = updated;
    await _save();
  }

  Future<void> markUploaded(List<String> ids) async {
    for (final id in ids) {
      final idx = _records.indexWhere((r) => r.id == id);
      if (idx != -1) {
        _records[idx] = _records[idx].copyWith(uploadStatus: UploadStatus.uploaded);
      }
    }
    await _save();
  }
}
