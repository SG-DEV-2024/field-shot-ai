import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ai_camera/services/storage_service.dart';
import 'package:ai_camera/services/upload_service.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/routes/app_pages.dart';

class MainController extends GetxController {
  static MainController get I => Get.find();

  final totalToday = 0.obs;
  final pendingCount = 0.obs;
  final uploadedCount = 0.obs;
  final isOnline = true.obs;
  final isUploading = false.obs;

  StreamSubscription? _connectivitySub;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    refresh();
  }

  void _initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    isOnline.value = result.any((r) => r != ConnectivityResult.none);

    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      isOnline.value = results.any((r) => r != ConnectivityResult.none);
    });
  }

  @override
  void onClose() {
    _connectivitySub?.cancel();
    super.onClose();
  }

  void refresh() {
    totalToday.value = StorageService.I.totalToday;
    pendingCount.value = StorageService.I.pendingCount;
    uploadedCount.value = StorageService.I.uploadedCount;
  }

  void goToCamera(SurveyType type) {
    Get.toNamed(AppRoutes.camera, arguments: {'surveyType': type})?.then((_) => refresh());
  }

  void goToArchive() {
    Get.toNamed(AppRoutes.archive)?.then((_) => refresh());
  }

  Future<void> uploadPending() async {
    if (isUploading.value || pendingCount.value == 0) return;
    isUploading.value = true;

    final pending = StorageService.I.todayRecords
        .where((r) => r.uploadStatus == UploadStatus.pending)
        .toList();

    for (final record in pending) {
      final success = await UploadService.I.uploadRecord(
        id: record.id,
        photoPath: record.photoPath,
        value: record.value,
        surveyType: record.surveyType.label,
        note: record.note,
        timestamp: record.timestamp,
      );
      if (success) {
        await StorageService.I.markUploaded([record.id]);
      }
    }

    refresh();
    isUploading.value = false;

    final ctx = Get.context;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('${pending.length}건 전송 완료'),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
