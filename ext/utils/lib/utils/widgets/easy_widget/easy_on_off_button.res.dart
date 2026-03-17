part of 'easy_on_off_button.dart';

ButtonStyle get _interlockButton => ElevatedButton.styleFrom(
      foregroundColor: WtColors.background,
      backgroundColor: const Color(0xFF32B13E),
      minimumSize: const Size(104, 0),
      padding: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // textStyle: WtTextStyle.size16M,
    );

ButtonStyle get _analysisButton => ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffEDB200),
      // textStyle: WtTextStyle.size14B.background,
      minimumSize: const Size.fromHeight(32),
      padding: EdgeInsets.zero,
    );

ButtonStyle get _detailButton => ElevatedButton.styleFrom(
      foregroundColor: WtColors.background,
      backgroundColor: WtColors.primary,
      minimumSize: Size.zero,
      padding: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // textStyle: WtTextStyle.size16M,
    );

ButtonStyle get _layoutMapButton => ElevatedButton.styleFrom(
      foregroundColor: WtColors.primary,
      backgroundColor: WtColors.gray3,
      minimumSize: const Size(40, 40),
      padding: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // textStyle: WtTextStyle.size14B.primary,
    );

ButtonStyle get _locationMapButton => ElevatedButton.styleFrom(
      foregroundColor: WtColors.primary,
      backgroundColor: WtColors.gray3,
      minimumSize: const Size(40, 40),
      padding: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // textStyle: WtTextStyle.size14B.primary,
    );

ButtonStyle get _reloadButton => ElevatedButton.styleFrom(
      foregroundColor: WtColors.background,
      backgroundColor: WtColors.gray1,
      minimumSize: Size.zero,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // textStyle: WtTextStyle.size16M,
    );

ButtonStyle get _connectingButton => ElevatedButton.styleFrom(
      foregroundColor: WtColors.background,
      backgroundColor: WtColors.error,
      minimumSize: Size.zero,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // textStyle: WtTextStyle.size16M,
    );
