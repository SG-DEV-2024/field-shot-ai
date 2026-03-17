part of 'easy_elevated_button.dart';

ButtonStyle get _subRedButton => ElevatedButton.styleFrom(
      foregroundColor: WtColors.background,
      backgroundColor: WtColors.error,
      // backgroundColor: const Color(0xffF56B3F),
    );

ButtonStyle get _smallButton => ElevatedButton.styleFrom(
      backgroundColor: WtColors.primary,
      // textStyle: WtTextStyle.size14B,
      minimumSize: const Size.fromHeight(28),
      padding: EdgeInsets.zero,
    );

//xx Device를 위한 잠시 사용되는 값들입니다.
ButtonStyle _colorButton(Color? backgroundColor) => ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      // textStyle: WtTextStyle.size14B.white,
      minimumSize: const Size.fromHeight(32),
      padding: EdgeInsets.zero,
    );

ButtonStyle get _squareButton => ElevatedButton.styleFrom(
      disabledBackgroundColor: const Color(0xff3a8afd),
      disabledForegroundColor: const Color(0xffffffff),
      backgroundColor: const Color(0xffeeeeee),
      foregroundColor: const Color(0xff959595),
      textStyle: WtTextStyle.titleMedium,
      minimumSize: const Size(48.0, 48.0),
      maximumSize: const Size(48.0, 48.0),
      padding: EdgeInsets.zero,
    );

ButtonStyle get _squareDimButton => ElevatedButton.styleFrom(
      disabledBackgroundColor: WtColors.gray3, //xx grey5
      disabledForegroundColor: const Color(0xff959595).withOpacity(0.3),
      backgroundColor: const Color(0xffeeeeee),
      foregroundColor: const Color(0xff959595),
      textStyle: WtTextStyle.titleMedium,
      minimumSize: const Size(48.0, 48.0),
      maximumSize: const Size(48.0, 48.0),
      padding: EdgeInsets.zero,
    );

ButtonStyle get _minimumButton => ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
    );
