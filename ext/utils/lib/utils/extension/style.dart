import 'dart:ui';

import 'package:utils/utils.dart';

extension WtTextStyleExtension on TextStyle {
  TextStyle get primary => copyWith(color: WtColors.primary);
  TextStyle get primaryContainer => copyWith(color: WtColors.primaryContainer);
  TextStyle get onPrimaryContainer => copyWith(color: WtColors.onPrimaryContainer);
  TextStyle get secondary => copyWith(color: WtColors.secondary);
  TextStyle get error => copyWith(color: WtColors.error);
  TextStyle get back => copyWith(color: WtColors.background);
  TextStyle get onBack => copyWith(color: WtColors.onBackground);

  TextStyle get white => copyWith(color: Colors.white);
  TextStyle get black => copyWith(color: Colors.black);
  TextStyle get gray1 => copyWith(color: WtColors.gray1);
  TextStyle get gray2 => copyWith(color: WtColors.gray2);
  TextStyle get gray3 => copyWith(color: WtColors.gray3);
  TextStyle get gray4 => copyWith(color: WtColors.gray4);

  TextStyle get osWhite => copyWith(color: WtColors.osWhite);
  TextStyle get osGray1 => copyWith(color: WtColors.osGray1);
  TextStyle get osGray2 => copyWith(color: WtColors.osGray2);
  TextStyle get osGray3 => copyWith(color: WtColors.osGray3);
  TextStyle get osGray4 => copyWith(color: WtColors.osGray4);
  TextStyle get osGrayBorder => copyWith(color: WtColors.osGrayBorder);
  TextStyle get osGrayBorder2 => copyWith(color: WtColors.osGrayBorder2);
  TextStyle get osGrayText => copyWith(color: WtColors.osGrayText);
  TextStyle get osGrayText2 => copyWith(color: WtColors.osGrayText2);
  TextStyle get osGrayBackground => copyWith(color: WtColors.osGrayBorder2);
  TextStyle get osBackground => copyWith(color: WtColors.osBackground);
  TextStyle get osErrorText => copyWith(color: WtColors.osErrorText);
  TextStyle get osStrokeButton => copyWith(color: WtColors.osStrokeButton);
  TextStyle get osBlack => copyWith(color: WtColors.osBlack);

  // TextStyle get outline => copyWith(color: colorScheme.outline);

  // TextStyle get outlineVariant => copyWith(color: colorScheme.outlineVariant);

  // TextStyle get outlineVariantShade300 => copyWith(color: WtColors.outlineVariantShade300);

  /// 스타일 색상 추가
  ///
  /// #614385
  ///
  /// rgba(97, 67, 133, 1)
  // TextStyle get violet => copyWith(color: WtColors.violet);

  // /// 스타일 색상 추가
  // ///
  // /// #87ABD6
  // ///
  // /// rgba(135, 171, 214, 1)
  // TextStyle get indigo => copyWith(color: WtColors.indigo);

  // /// 스타일 색상 추가
  // ///
  // /// #15224F
  // ///
  // /// rgba(21, 34, 79, 1)
  // TextStyle get subBlue => copyWith(color: WtColors.subBlue);

  // /// 스타일 색상 추가
  // ///
  // /// #15224F
  // ///
  // /// rgba(21, 34, 79, 1)
  // TextStyle get subBack => copyWith(color: WtColors.subBack);

  // /// 스타일 색상 추가
  // ///
  // /// #5F5F5F
  // ///
  // /// rgba(95, 95, 95, 1)
  // TextStyle get subDark => copyWith(color: WtColors.subDark);

  // /// 스타일 색상 추가
  // ///
  // /// #87ABD6
  // ///
  // /// rgba(245, 107, 63, 1);
  // TextStyle get subRed => copyWith(color: WtColors.subRed);

  // /// 스타일 색상 추가
  // ///
  // /// #E02020
  // ///
  // /// rgba(224, 32, 32, 1)
  // TextStyle get warning => copyWith(color: WtColors.warning);

  // /// 스타일 색상 추가
  // ///
  // /// #FFFFFF
  // ///
  // /// rgba(255, 255, 255, 1)
  // TextStyle get white => copyWith(color: WtColors.white);

  // /// 스타일 색상 추가
  // ///
  // /// #2D2D2D
  // ///
  // /// rgba(45, 45, 45, 1)
  // TextStyle get grey0 => copyWith(color: WtColors.grey0);

  // /// 스타일 색상 추가
  // ///
  // /// #8F8F8F
  // ///
  // /// rgba(143, 143, 143, 1)
  // TextStyle get grey1 => copyWith(color: WtColors.grey1);

  // /// 스타일 색상 추가
  // ///
  // /// #B7B7B7
  // ///
  // /// rgba(183, 183, 183, 1)
  // TextStyle get grey2 => copyWith(color: WtColors.grey2);

  // /// 스타일 색상 추가
  // ///
  // /// #D8D8D8
  // ///
  // /// rgba(216, 216, 216, 1)
  // TextStyle get grey3 => copyWith(color: WtColors.grey3);

  // /// 스타일 색상 추가
  // ///
  // /// #EFEFEF
  // ///
  // /// rgba(239, 239, 239, 1)
  // TextStyle get grey4 => copyWith(color: WtColors.grey4);

  // /// 스타일 색상 추가
  // ///
  // /// #F8F8F8
  // ///
  // /// rgba(248, 248, 248, 1)
  // TextStyle get grey5 => copyWith(color: WtColors.grey5);

  // /// 스타일 색상 추가
  // ///
  // /// #000000
  // ///
  // /// rgba(0, 0, 0, 1)
  // TextStyle get black => copyWith(color: WtColors.black);

  // /// #0084FF
  // ///
  // /// rgba(0, 132, 255, 1)
  // TextStyle get link => copyWith(color: WtColors.link);

  // /// #907BAA
  // ///
  // /// rgba(144, 123, 170, 1)
  // TextStyle get fabs => copyWith(color: WtColors.fabs);

  // /// #469C51
  // ///
  // /// rgba(70, 156, 81, 1)
  // TextStyle get join => copyWith(color: WtColors.join);

  // /// #FCE9E9
  // ///
  // /// rgba(252, 233, 233, 1)
  // TextStyle get etc1 => copyWith(color: WtColors.etc1);

  // /// #E9F8EF
  // ///
  // /// rgba(233, 248, 239, 1)
  // TextStyle get etc2 => copyWith(color: WtColors.etc2);

  // /// #7FDA4A
  // ///
  // /// rgba(127, 218, 74, 1)
  // TextStyle get right => copyWith(color: WtColors.right);

  /// 문자열 높이 조절
  ///
  /// height 1.0
  TextStyle get h1_0 => copyWith(height: 1.0);

  /// 문자열 높이 조절
  ///
  /// height 1.2
  TextStyle get h1_2 => copyWith(height: 1.2);

  /// 문자열 높이 조절
  ///
  /// height 1.4
  TextStyle get h1_4 => copyWith(height: 1.41667);

  /// 문자열 높이 조절
  ///
  /// height 1.5
  TextStyle get h1_5 => copyWith(height: 1.5);

  /// 문자열 높이 조절
  ///
  /// height 1.7
  TextStyle get h1_7 => copyWith(height: 1.7142857);

  /// 문자열 높이 조절
  ///
  /// height 2.0
  TextStyle get h2_0 => copyWith(height: 2.0);

  /// 문자열 리딩 조절
  ///
  /// leading
  TextStyle leading(double value) => copyWith(fontVariations: [FontVariation('lead', value - 1.0)]);

  /// 문자열 두께 조절
  ///
  /// regular
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  /// 문자열 두께 조절
  ///
  /// medium
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// 문자열 두께 조절
  ///
  /// bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get fixed => apply(fontSizeFactor: 1.0 / Get.textScaleFactor);

  TextStyle edit({required double height}) =>
      copyWith(height: height / fontSize!, leadingDistribution: TextLeadingDistribution.even);
}
