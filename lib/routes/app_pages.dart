import 'package:ai_camera/index.dart';
import 'package:ai_camera/pages/main/main_page.dart';
import 'package:ai_camera/pages/camera/camera_page.dart';
import 'package:ai_camera/pages/data_input/data_input_page.dart';
import 'package:ai_camera/pages/archive/archive_page.dart';
import 'package:ai_camera/pages/photo_viewer/photo_viewer_page.dart';

abstract class AppRoutes {
  static const main = '/';
  static const camera = '/camera';
  static const dataInput = '/data-input';
  static const archive = '/archive';
  static const photoViewer = '/photo-viewer';
}

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.main, page: () => const MainPage()),
    GetPage(name: AppRoutes.camera, page: () => const CameraPage()),
    GetPage(name: AppRoutes.dataInput, page: () => const DataInputPage()),
    GetPage(name: AppRoutes.archive, page: () => const ArchivePage()),
    GetPage(name: AppRoutes.photoViewer, page: () => const PhotoViewerPage()),
  ];
}
