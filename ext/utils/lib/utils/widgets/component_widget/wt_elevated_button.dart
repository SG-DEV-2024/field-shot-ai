import 'package:utils/utils.dart';

class WtElevatedButton extends ElevatedButton {
  WtElevatedButton({
    Key? key,
    double? width,
    double? height,
    Color? color,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required Widget? child,
    bool showTapEffect = true,
  })  : assert(color == null || style == null, 'color와 style을 동시에 사용 할 수 없습니다.'),
        super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: (style ?? const ButtonStyle()).copyWith(
            minimumSize:
                width != null || height != null ? MaterialStateProperty.all(Size((width ?? 64), (height ?? 52))) : null,
            foregroundColor: color != null ? materialStateColor(_getFontColor(color),disabled:  _getDisabledColor(color)) : null,
            backgroundColor: color != null ? materialStateColor(color) : null,
            shape: borderRadius != null
                ? MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: borderRadius,
                    ),
                  )
                : null,
            padding: padding != null ? MaterialStateProperty.all<EdgeInsetsGeometry>(padding) : null,
            splashFactory: showTapEffect ? null : NoSplash.splashFactory,
            textStyle: color != null ? _getTextStyle(color) : null,
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: child,
        );

  static Color _getFontColor(Color color) {
    if ([WtColors.background, WtColors.gray4].contains(color)) {
      return WtColors.onPrimaryContainer;
    } else if (color == WtColors.error) {
      return WtColors.error;
    } else {
      return WtColors.background;
    }
  }

  static Color _getDisabledColor(Color color) {
    if ([WtColors.background, WtColors.gray4].contains(color)) {
      return WtColors.gray2;
    } else if (color == WtColors.error) {
      return WtColors.gray2;
    } else {
      return WtColors.gray3;
    }
  }

  static MaterialStateProperty<TextStyle?>? _getTextStyle(Color color) {
    if ([WtColors.primaryContainer, WtColors.background, WtColors.gray4, WtColors.error].contains(color)) {
      return MaterialStateProperty.all<TextStyle>(WtTextStyle.labelLarge);
    } else {
      return null;
    }
  }
}
