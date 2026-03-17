part of 'easy_text_button.dart';

ButtonStyle get _warningButton => TextButton.styleFrom(
      foregroundColor: WtColors.error,
      // textStyle: WtTextStyle.size16B,
    ).copyWith(
      overlayColor: materialSolidColor(WtColors.error.withOpacity(0.05)),
    );

ButtonStyle get _osMainButton => TextButton.styleFrom(
      textStyle: WtTextStyle.osButtonNormal,
      foregroundColor: WtColors.osBlueButton,
    );
