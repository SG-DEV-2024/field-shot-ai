import 'package:get/get.dart';
import 'package:ai_camera/services/storage_service.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/routes/app_pages.dart';

class MainController extends GetxController {
  static MainController get I => Get.find();

  final totalToday = 0.obs;
  final pendingCount = 0.obs;
  final uploadedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refresh();
  }

  void refresh() {
    totalToday.value = StorageService.I.totalToday;
    pendingCount.value = StorageService.I.pendingCount;
    uploadedCount.value = StorageService.I.uploadedCount;
  }

  void goToCamera(SurveyType type) {
    Get.toNamed(AppRoutes.camera, arguments: {'surveyType': type});
  }

  void goToArchive() {
    Get.toNamed(AppRoutes.archive)?.then((_) => refresh());
  }
}
