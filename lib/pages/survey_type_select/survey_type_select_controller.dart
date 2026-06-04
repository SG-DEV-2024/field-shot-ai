import 'package:get/get.dart';
import 'package:ai_camera/models/survey_record.dart';
import 'package:ai_camera/models/measurement_subtype.dart';
import 'package:ai_camera/routes/app_pages.dart';

/// S-002 규격조사 유형 선택. 선택 후 카메라 라우팅만 담당.
class SurveyTypeSelectController extends GetxController {
  void select(MeasurementSubtype subtype) {
    Get.toNamed(AppRoutes.camera, arguments: {
      'surveyType': SurveyType.dimension,
      'subtype': subtype,
    });
  }
}
