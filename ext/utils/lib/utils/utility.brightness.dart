part of 'utility.dart';

Brightness getBrightness([int? brightNo]) {
  brightNo ??= prefs.getInt('bright') ?? 1;
  return brightNo == 1
      ? Brightness.light
      : (brightNo == 2 ? Brightness.dark : WidgetsBinding.instance.platformDispatcher.platformBrightness);
}

setBrightness(int brightNo, [GetxController? controller]) {
    prefs.setInt('bright', brightNo);
    //xx changedBrightness(controller);
}

//xx changedBrightness([GetxController? controller]) {
//   final brightComp = getBrightness();
//   if (brightness != brightComp) {
//     brightness = brightComp;
//     setColorScheme();
//     Get.changeThemeMode(brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark);
//     try {
//       if (controller != null) {
//         controller.update([ID.whole]);
//       } else {
//         mainController.update([ID.whole]);
//       }
//     } catch (_) {}
//   }
// }

setColorScheme() {
  colorScheme = brightness == Brightness.light ? lightColorSchemeV2 : darkColorSchemeV2;
  //xx highlighterOpacity = brightness == Brightness.light ? 0.33 : 0.27;
}
