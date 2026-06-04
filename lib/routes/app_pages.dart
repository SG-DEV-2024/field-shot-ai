import 'package:ai_camera/index.dart';
import 'package:ai_camera/pages/main/main_page.dart';
import 'package:ai_camera/pages/camera/camera_page.dart';
import 'package:ai_camera/pages/data_input/data_input_page.dart';
import 'package:ai_camera/pages/archive/archive_page.dart';
import 'package:ai_camera/pages/photo_viewer/photo_viewer_page.dart';
import 'package:ai_camera/pages/survey_type_select/survey_type_select_page.dart';
import 'package:ai_camera/pages/annotate/annotate_page.dart';
import 'package:ai_camera/pages/dimension_input/dimension_input_page.dart';

abstract class AppRoutes {
  // v1 기존
  static const main = '/';
  static const camera = '/camera';
  static const dataInput = '/data-input';
  static const archive = '/archive';
  static const photoViewer = '/photo-viewer';

  // v2 신규 (규격조사)
  static const surveyTypeSelect = '/survey-type-select'; // S-002
  static const annotate = '/annotate'; // S-004 (폭/간격) · S-007 (홀 깊이)
  static const dimensionInput = '/dimension-input'; // S-005 (폭/간격) · S-008 (홀 깊이)
}

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.main, page: () => const MainPage()),
    GetPage(name: AppRoutes.camera, page: () => const CameraPage()),
    GetPage(name: AppRoutes.dataInput, page: () => const DataInputPage()),
    GetPage(name: AppRoutes.archive, page: () => const ArchivePage()),
    GetPage(name: AppRoutes.photoViewer, page: () => const PhotoViewerPage()),
    GetPage(name: AppRoutes.surveyTypeSelect, page: () => const SurveyTypeSelectPage()),
    GetPage(name: AppRoutes.annotate, page: () => const AnnotatePage()),
    GetPage(name: AppRoutes.dimensionInput, page: () => const DimensionInputPage()),
  ];
}
