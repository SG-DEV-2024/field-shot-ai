import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/routes/app_pages.dart';
import 'package:ai_camera/global.dart';

enum FlashMode2 { auto, on, off }

class CameraController2 extends GetxController {
  static CameraController2 get I => Get.find();

  late CameraController cameraController;
  final isInitialized = false.obs;
  final zoomLevel = 2.0.obs; // 1x, 2x, 3x
  final flashMode = FlashMode2.auto.obs;
  final lastPhotoPath = ''.obs;
  final isCapturing = false.obs;

  late SurveyType surveyType;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    surveyType = args?['surveyType'] ?? SurveyType.carbonation;
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (cameras.isEmpty) return;
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await cameraController.initialize();
    await cameraController.setFlashMode(FlashMode.auto);
    await _applyZoom(zoomLevel.value);
    isInitialized.value = true;
  }

  Future<void> _applyZoom(double zoom) async {
    if (!cameraController.value.isInitialized) return;
    final minZoom = await cameraController.getMinZoomLevel();
    final maxZoom = await cameraController.getMaxZoomLevel();
    final clamped = zoom.clamp(minZoom, maxZoom);
    await cameraController.setZoomLevel(clamped);
  }

  Future<void> setZoom(double zoom) async {
    zoomLevel.value = zoom;
    await _applyZoom(zoom);
  }

  Future<void> toggleFlash() async {
    switch (flashMode.value) {
      case FlashMode2.auto:
        flashMode.value = FlashMode2.on;
        await cameraController.setFlashMode(FlashMode.always);
        break;
      case FlashMode2.on:
        flashMode.value = FlashMode2.off;
        await cameraController.setFlashMode(FlashMode.off);
        break;
      case FlashMode2.off:
        flashMode.value = FlashMode2.auto;
        await cameraController.setFlashMode(FlashMode.auto);
        break;
    }
  }

  String get flashLabel {
    switch (flashMode.value) {
      case FlashMode2.auto:
        return '⚡ Auto';
      case FlashMode2.on:
        return '⚡ On';
      case FlashMode2.off:
        return '⚡ Off';
    }
  }

  Future<void> capture() async {
    if (isCapturing.value || !isInitialized.value) return;
    isCapturing.value = true;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/capture/photos');
      if (!await photoDir.exists()) await photoDir.create(recursive: true);

      final file = await cameraController.takePicture();
      final destPath = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(file.path).copy(destPath);
      lastPhotoPath.value = destPath;

      // 촬영 후 데이터 입력 화면으로 이동
      Get.toNamed(AppRoutes.dataInput, arguments: {
        'photoPath': destPath,
        'surveyType': surveyType,
      })?.then((result) {
        if (result == 'continue') {
          // 계속 촬영 - 현재 화면 유지
        } else if (result == 'main') {
          Get.until((route) => Get.currentRoute == AppRoutes.main);
        }
      });
    } finally {
      isCapturing.value = false;
    }
  }

  @override
  void onClose() {
    if (isInitialized.value) cameraController.dispose();
    super.onClose();
  }
}
