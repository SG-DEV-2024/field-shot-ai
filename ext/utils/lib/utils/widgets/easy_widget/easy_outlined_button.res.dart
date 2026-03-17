part of 'easy_outlined_button.dart';

ButtonStyle get _errorStyle => OutlinedButton.styleFrom(
      foregroundColor: WtColors.error,
    ).copyWith(
      side: materialStateBorder(WtColors.error, WtColors.error.withOpacity(0.5)),
      overlayColor: materialSolidColor(WtColors.error.withOpacity(0.05)),
    );

ButtonStyle get _smallStyle => OutlinedButton.styleFrom(
      minimumSize: const Size(32.0, 32.0),
    );

ButtonStyle get _primaryContainerStyle => OutlinedButton.styleFrom(
      backgroundColor: WtColors.primaryContainer.withOpacity(0.5),
      foregroundColor: WtColors.onPrimaryContainer,
    );

ButtonStyle get _secondaryContainerStyle => OutlinedButton.styleFrom(
      backgroundColor: WtColors.secondaryContainer.withOpacity(0.5),
      foregroundColor: WtColors.onSecondaryContainer,
    );

ButtonStyle get _tertiaryContainerStyle => OutlinedButton.styleFrom(
      backgroundColor: WtColors.tertiaryContainer.withOpacity(0.5),
      foregroundColor: WtColors.onTertiaryContainer,
    );

//xx Device를 위한 잠시 사용되는 값들입니다.
ButtonStyle get _minimumButton => OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
    );

//* 지원N
ButtonStyle _osMainStyle({double width = 188.0, double height = 51.0}) => OutlinedButton.styleFrom(
      textStyle: height > 60.0 ? WtTextStyle.osTitleMediumBold : WtTextStyle.osButtonNormalBold,
      minimumSize: Size(width, height),
      backgroundColor: WtColors.osWhite,
      foregroundColor: WtColors.osBlack,
    ).copyWith(
      side: materialStateBorder(WtColors.osStrokeButton, WtColors.osGray4),
    );
ButtonStyle _osErrorStyle({double width = 188.0, double height = 51.0}) => OutlinedButton.styleFrom(
      textStyle: height > 60.0 ? WtTextStyle.osTitleMediumBold : WtTextStyle.osButtonNormalBold,
      minimumSize: Size(width, height),
      backgroundColor: WtColors.osWhite,
      foregroundColor: WtColors.osErrorText,
    ).copyWith(
      side: materialStateBorder(WtColors.osStrokeButton, WtColors.osGray4),
    );
