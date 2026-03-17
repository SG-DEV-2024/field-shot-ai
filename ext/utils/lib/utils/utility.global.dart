part of 'utility.dart';

late Brightness brightness;
late ColorScheme colorScheme;

late final SharedPreferencesWithCache prefs;
late final FToast fToast;

Future<void> initializeUtils() async {
  // prefs = await SharedPreferences.getInstance();
  prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());

  brightness = getBrightness();
  setColorScheme();

  // globalKeyList = List.generate(3, (index) => Get.nestedKey(index)!);
  WidgetsBinding.instance.addPostFrameCallback((_) => fToast = FToast());
}
