import 'package:camera/camera.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:ai_camera/index.dart';
import 'package:ai_camera/services/storage_service.dart';
import 'package:ai_camera/pages/main/main_page.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  await StorageService.I.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: '현장촬영AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
        fontFamily: 'Pretendard',
      ),
      getPages: AppPages.routes,
      initialRoute: AppRoutes.main,
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
  }
}
