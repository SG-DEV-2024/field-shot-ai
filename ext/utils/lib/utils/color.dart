import 'package:utils/utils.dart';

class WtColors {
  WtColors._();

  static Color get outlineVariantShade150 => Color.lerp(colorScheme.background, colorScheme.outlineVariant, 0.15)!;
  // static Color get outlineVariantShade150 => colorScheme.outlineVariant.withOpacity(0.15);

  static Color get outlineVariantShade300 => Color.lerp(colorScheme.background, colorScheme.outlineVariant, 0.3)!;
  // static Color get outlineVariantShade300 => colorScheme.outlineVariant.withOpacity(0.3);

  static Color get outlineVariantShade500 => Color.lerp(colorScheme.background, colorScheme.outlineVariant, 0.5)!;
  //static Color get outlineVariantShade500 => colorScheme.outlineVariant.withOpacity(0.5);

  static Color get backgroundWithAlpha0 => colorScheme.background.withAlpha(0);

  static Color get primary => colorScheme.primary;
  static Color get primaryContainer => colorScheme.primaryContainer;
  static Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  static Color get secondary => colorScheme.secondary;
  static Color get secondaryContainer => colorScheme.secondaryContainer;
  static Color get onSecondaryContainer => colorScheme.onSecondaryContainer;
  static Color get tertiary => colorScheme.tertiary;
  static Color get tertiaryContainer => colorScheme.tertiaryContainer;
  static Color get onTertiaryContainer => colorScheme.onTertiaryContainer;
  static Color get error => colorScheme.error;
  static Color get errorContainer => colorScheme.errorContainer;
  static Color get errorCard => Color.lerp(gray4, errorContainer, 0.2)!;
  static Color get onError => colorScheme.onError;
  static Color get background => colorScheme.background;
  static Color get onBackground => colorScheme.onBackground;
  static Color get inverseSurface => colorScheme.inverseSurface;
  static Color get onInverseSurface => colorScheme.onInverseSurface;

  static Color get gray1 => colorScheme.outline;
  static Color get gray2 => colorScheme.outlineVariant;
  static Color get gray3 => colorScheme.surfaceVariant;
  static Color get gray4 => colorScheme.onInverseSurface;

  static const osBlueButton = Color(0xFF007AFF);
  static const osDarkBlueButton = Color(0xFF15294B);
  static const osNormalButtonText = Color(0xFFFFFFFF);
  static const osDisableButton = Color(0xFFD9D9D9);
  static const osError = Color(0xFFB3261E);
  // ...
  static const osWhite = Color(0xFFFFFFFF);
  static const osGray1 = Color(0xFFE8E8E8);
  static const osGray2 = Color(0xFFDFE2E6);
  static const osGray3 = Color(0xFFE4E4E4);
  static const osGray4 = Color(0xFFF2F2F2);
  static const osGrayBorder = Color(0xFF8B8E92);
  static const osGrayBorder2 = Color(0xFFD9D9D9);
  static const osGrayText = Color(0xFF3C3C3C);
  static const osGrayText2 = Color(0xFF6C6C6C);
  static const osGrayBackground = Color(0xFFD9D9D9);
  static const osBackground = Color(0x80FFFFFF);
  static const osErrorText = Color(0xFFEF2F24);
  static const osStrokeButton = Color(0xFF979797);
  static const osBlack = Color(0xFF000000);
  static const osGroup = Color(0xFF6792FF);
  static const osTableBasic = Color(0xFFFAFBFB);
  static const osTableSelected = Color(0xFFDFE2E6);
  static const osLabel = Color(0xFF42526D);
  static const osYellow = Color(0xFFFFCE0C);
  static const osPurple = Color(0xFFC70AE4);

  //* device
  static const subBlue = Color(0xFF15224F);
  static const subDark = Color(0xFF5F5F5F);
  static const subRed = Color(0xFFFD6B7D);
  static const subCyan = Color(0xFF00BBD6);
  static const subBack = Color(0xFFEDF2F9);
  static const subGreen = Color(0xFF32B13E);
  static const link = Color(0xFF0084FF);
  static const fabs = Color(0xFF907BAA);
  static const join = Color(0xFF24D626);
  static const bubble = Color(0xFFF1F4FD);
  static const etc1 = Color(0xFFFCE9E9);
  static const etc2 = Color(0xFFE9F8EF);
  static const right = Color(0xFF7FDA4A);
  static const crackManagement = Color(0xFF4D4E4D);
  static const fieldSurvey = Color(0xFF7E3D84);
  static const buildingManagement = Color(0xFF3D8473);
  static const etcManagement = Color(0xFF84533D);

  static const Color markerBlack = Color(0xFF000000);
  static const Color markerRose = Color(0xFFCE0214);
  static const Color markerBlue = Color(0xFF066DE9);
  static const Color markerGreen = Color(0xFF24A83C);
  static const Color markerPurple = Color(0xFFB143D4);
  static const Color markerYellow = Color(0xFFCFA101);
  static const Color markerSky = Color(0xFF04C9FE);
  static const Color markerWhite = Color(0xFFFFFFFF);
  static const Color markerUpdate = Color.fromARGB(255, 142, 76, 4);

  static const Color highlighterYellow = Color(0xFFFEEA3D);
  static const Color highlighterBlue = Color(0xFF89F1FF);
  static const Color highlighterGreen = Color(0xFF83FE83);
  static const Color highlighterPink = Color(0xFFFFB2B2);
  static const Color highlighterPurple = Color(0xFF9BB6FE);
  static const Color highlighterRose = Color(0xFFE3242B);
  static const Color highlighterGray = Color(0xFFDADADA);
  static Color highlighterRoseIcon = Color.lerp(Colors.white, highlighterRose, 0.55)!;

  // /// #614385
  // ///
  // /// rgba(97, 67, 133, 1)
  // static const violet = Color(0xFF614385);

  // /// #87ABD6
  // ///
  // /// rgba(135, 171, 214, 1)
  // static const indigo = Color(0xFF174996);

  // /// #15224F
  // ///
  // /// rgba(21, 34, 79, 1)
  // static const subBlue = Color(0xFF15224F);

  // /// #5F5F5F
  // ///
  // /// rgba(95, 95, 95, 1)
  // static const subDark = Color(0xFF5F5F5F);

  // /// #FD6B7D
  // ///
  // /// rgba(245, 107, 63, 1);
  // static const subRed = Color(0xFFFD6B7D);

  // /// #00BBD6
  // ///
  // /// rgba(0, 187, 214, 1);
  // static const subCyan = Color(0xFF00BBD6);

  // /// #EDF2F9
  // ///
  // /// rgba(237, 242, 249, 1)
  // static const subBack = Color(0xFFEDF2F9);

  // /// #EDF2F9
  // ///
  // /// rgba(237, 242, 249, 1)
  // static const subGreen = Color(0xFF32B13E);

  // /// #E02020
  // ///
  // /// rgba(255, 47, 47, 1)
  // static const warning = Color(0xFFFF2F2F);

  // /// #E74E39
  // ///
  // /// rgba(231, 78, 57, 1)
  // static const badge = Color(0xFFE74E39);

  // /// #FFFFFF
  // ///
  // /// rgba(255, 255, 255, 1)
  // static const white = Color(0xFFFFFFFF); // light, dark mode 두 모드에서 전부 흰색일 경우 - 예) 버튼 텍스트

  // /// #2D2D2D
  // ///
  // /// rgba(45, 45, 45, 1)
  // static const grey0 = Color(0xFF2D2D2D);

  // /// #8F8F8F
  // ///
  // /// rgba(143, 143, 143, 1)
  // static const grey1 = Color(0xFF8F8F8F);

  // /// #B7B7B7
  // ///
  // /// rgba(183, 183, 183, 1)
  // static const grey2 = Color(0xFFB7B7B7);

  // /// #D8D8D8
  // ///
  // /// rgba(216, 216, 216, 1)
  // static const grey3 = Color(0xFFD8D8D8);

  // /// #EFEFEF
  // ///
  // /// rgba(239, 239, 239, 1)
  // static const grey4 = Color(0xFFEFEFEF);

  // /// #F8F8F8
  // ///
  // /// rgba(248, 248, 248, 1)
  // static const grey5 = Color(0xFFF8F8F8);

  // /// #000000
  // ///
  // /// rgba(0, 0, 0, 1)
  // static const black = Color(0xFF000000); // light, dark mode 두 모드에서 전부 검은색일 경우

  // /// 배경색
  // ///
  // /// white모드 : #FFFFFF / rgba(255, 255, 255, 1)
  // ///
  // /// dark모드 : #000000 /rgba(0, 0, 0, 1)
  // static const background = Color(0xFFFFFFFF); // dark 모드에서는 어두운 계열색으로 바뀜

  // /// #0084FF
  // ///
  // /// rgba(0, 132, 255, 1)
  // static const link = Color(0xFF0084FF);

  // /// #907BAA
  // ///
  // /// rgba(144, 123, 170, 1)
  // static const fabs = Color(0xFF907BAA);

  // /// #469C51
  // ///
  // /// rgba(70, 156, 81, 1)
  // static const join = Color(0xFF24D626);

  // /// #F1F4FD
  // ///
  // /// rgba(207, 229, 255, 1)
  // static const bubble = Color(0xFFF1F4FD);

  // /// #FCE9E9
  // ///
  // /// rgba(252, 233, 233, 1)
  // static const etc1 = Color(0xFFFCE9E9);

  // /// #E9F8EF
  // ///
  // /// rgba(233, 248, 239, 1)
  // static const etc2 = Color(0xFFE9F8EF);

  // /// #7FDA4A
  // ///
  // /// rgba(127, 218, 74, 1)
  // static const right = Color(0xFF7FDA4A);

  // /// #4D4E4D
  // static const crackManagement = Color(0xFF4D4E4D);

  // /// #7E3D84
  // static const fieldSurvey = Color(0xFF7E3D84);

  // /// #3D8473
  // static const buildingManagement = Color(0xFF3D8473);

  // /// #84533D
  // static const etcManagement = Color(0xFF84533D);
}
