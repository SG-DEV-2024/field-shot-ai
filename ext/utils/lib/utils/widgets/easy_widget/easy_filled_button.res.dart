part of 'easy_filled_button.dart';

ButtonStyle get _smallStyle => FilledButton.styleFrom(
      minimumSize: const Size(32.0, 32.0),
    );

ButtonStyle get _selectStyle => FilledButton.styleFrom(
      textStyle: WtTextStyle.titleMedium,
      minimumSize: const Size(32.0, 48.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
    );

ButtonStyle get _selectSmallStyle => FilledButton.styleFrom(
      textStyle: WtTextStyle.titleMedium.copyWith(fontSize: 16.0 / Get.textScaleFactor),
      minimumSize: const Size(32.0, 48.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
    );

ButtonStyle get _secondaryStyle => FilledButton.styleFrom(
      backgroundColor: colorScheme.secondary,
      foregroundColor: colorScheme.onSecondary,
    );

ButtonStyle get _secondaryTonal => FilledButton.styleFrom(
      backgroundColor: colorScheme.secondaryContainer,
      foregroundColor: colorScheme.onSecondaryContainer,
    );

ButtonStyle get _tertiaryStyle => FilledButton.styleFrom(
      backgroundColor: colorScheme.tertiary,
      foregroundColor: colorScheme.onTertiary,
    );

ButtonStyle get _tertiaryTonal => FilledButton.styleFrom(
      backgroundColor: colorScheme.tertiaryContainer,
      foregroundColor: colorScheme.onTertiaryContainer,
    );

ButtonStyle get _errorStyle => FilledButton.styleFrom(
      backgroundColor: colorScheme.error,
      foregroundColor: colorScheme.onError,
    );

ButtonStyle get _errorTonal => FilledButton.styleFrom(
      backgroundColor: colorScheme.errorContainer,
      foregroundColor: colorScheme.onErrorContainer,
    );

ButtonStyle _colorButton(Color? backgroundColor) => FilledButton.styleFrom(
      backgroundColor: backgroundColor,
      // textStyle: WtTextStyle.size14B.white,
      minimumSize: const Size.fromHeight(32),
      padding: EdgeInsets.zero,
    );

//xx 옥유아이 되는데로 넣은 것
ButtonStyle get _largeMainStyle => FilledButton.styleFrom(
      textStyle: WtTextStyle.titleLarge.bold,
      minimumSize: const Size(188.0, 48.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
    );

//* 지원N
ButtonStyle _osMainStyle({double width = 188.0, double height = 51.0}) => FilledButton.styleFrom(
      textStyle: height > 60.0 ? WtTextStyle.osTitleMediumBold : WtTextStyle.osButtonNormalBold,
      minimumSize: Size(width, height),
      backgroundColor: WtColors.osBlueButton,
      foregroundColor: WtColors.osNormalButtonText,
    );
ButtonStyle _osSmallStyle() => FilledButton.styleFrom(
      textStyle: WtTextStyle.osButtonNormalBold,
      minimumSize: const Size(32, 32),
      backgroundColor: WtColors.osBlueButton,
      foregroundColor: WtColors.osNormalButtonText,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
    );

ButtonStyle _osTinyStyle() => FilledButton.styleFrom(
      textStyle: WtTextStyle.osButtonNormalBold,
      minimumSize: const Size(24, 24),
      backgroundColor: WtColors.osBlueButton,
      foregroundColor: WtColors.osNormalButtonText,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
