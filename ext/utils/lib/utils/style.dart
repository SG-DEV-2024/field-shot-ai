import 'package:utils/utils.dart';

class WtTextStyle {
  WtTextStyle._();

  // 시스템 폰트 사용 (fontFamily 제거)

  static TextStyle get osButtonNormal => titleMedium.regular;
  static TextStyle get osButtonNormalBold => titleMedium.bold;
  static TextStyle get osButtonSmall => titleSmall.regular;
  static TextStyle get osButtonSmallBold => titleSmall.bold;
  static TextStyle get osTextBig => bodyLarge;
  static TextStyle get osTextBigBold => bodyLarge.medium;
  static TextStyle get osTextMedium => bodyMedium;
  static TextStyle get osTextMediumBold => bodyMedium.medium;
  static TextStyle get osTextSmall => bodySmall;
  static TextStyle get osTextSmallBold => bodySmall.medium;
  static TextStyle get osTextMini => labelSmall;
  static TextStyle get osTextMiniBold => labelSmall.medium;
  static TextStyle get osTitleHuge => titleLarge.bold;
  static TextStyle get osTitleBig => titleBig.bold;
  static TextStyle get osTitleMedium => titleMid;
  static TextStyle get osTitleMediumBold => titleMid.bold;

  /// weight : 400, line-height : 64, size : 57
  static const displayLarge = TextStyle(
    fontVariations: [FontVariation('lead', 64 / 57 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 57,
    height: 1.0,
    letterSpacing: -0.25,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 400, line-height : 52, size : 45
  static const displayMedium = TextStyle(
    fontVariations: [FontVariation('lead', 52 / 45 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 45,
    height: 1.0,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 400, line-height : 44, size : 36
  static const displaySmall = TextStyle(
    fontVariations: [FontVariation('lead', 44 / 36 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 36,
    height: 1.0,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /////////////////////////////////////////////////////////////////////////////

  /// weight : 400, line-height : 40, size : 32
  static const headlineLarge = TextStyle(
    fontVariations: [FontVariation('lead', 40 / 32 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 32,
    height: 1.0,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 400, line-height : 36, size : 28
  static const headlineMedium = TextStyle(
    fontVariations: [FontVariation('lead', 36 / 28 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 28,
    height: 1.0,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 400, line-height : 32, size : 24
  static const headlineSmall = TextStyle(
    fontVariations: [FontVariation('lead', 32 / 24 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 24,
    height: 1.0,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /////////////////////////////////////////////////////////////////////////////

  /// weight : 400, line-height : 28, size : 22
  static const titleLarge = TextStyle(
    fontVariations: [FontVariation('lead', 28 / 22 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 22,
    height: 1.0,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  static const titleBig = TextStyle(
    fontVariations: [FontVariation('lead', 26 / 20 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 1.0,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  static const titleMid = TextStyle(
    fontVariations: [FontVariation('lead', 24 / 20 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 1.0,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 500, line-height : 24, size : 16
  static const titleMedium = TextStyle(
    fontVariations: [FontVariation('lead', 24 / 16 - 1)],
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.0,
    letterSpacing: 0.15,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 500, line-height : 20, size : 14
  static const titleSmall = TextStyle(
    fontVariations: [FontVariation('lead', 20 / 14 - 1)],
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.0,
    letterSpacing: 0.1,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /////////////////////////////////////////////////////////////////////////////

  /// weight : 500, line-height : 20, size : 14
  static const labelLarge = TextStyle(
    fontVariations: [FontVariation('lead', 20 / 14 - 1)],
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.0,
    letterSpacing: 0.1,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 500, line-height : 16, size : 12
  static const labelMedium = TextStyle(
    fontVariations: [FontVariation('lead', 16 / 12 - 1)],
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.0,
    letterSpacing: 0.5,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 500, line-height : 14, size : 10
  static const labelSmall = TextStyle(
    fontVariations: [FontVariation('lead', 14 / 10 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 1.0,
    letterSpacing: 0.5,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /////////////////////////////////////////////////////////////////////////////

  /// weight : 400, line-height : 24, size : 16
  static const bodyLarge = TextStyle(
    fontVariations: [FontVariation('lead', 24 / 16 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.0,
    letterSpacing: 0.5,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 400, line-height : 20, size : 14
  static const bodyMedium = TextStyle(
    fontVariations: [FontVariation('lead', 20 / 14 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.0,
    letterSpacing: 0.25,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /// weight : 400, line-height : 16, size : 12
  static const bodySmall = TextStyle(
    fontVariations: [FontVariation('lead', 16 / 12 - 1)],
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.0,
    letterSpacing: 0.4,
    textBaseline: TextBaseline.ideographic,
    color: Colors.black, //?
  );

  /////////////////////////////////////////////////////////////////////////////

  static TextStyle get primary => TextStyle(color: colorScheme.primary);

  static TextStyle get error => TextStyle(color: colorScheme.error);
}
