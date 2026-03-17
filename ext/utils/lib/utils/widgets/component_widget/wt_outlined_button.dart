import 'package:utils/utils.dart';

class WtOutlinedButton extends OutlinedButton {
  WtOutlinedButton({
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
    required Widget child,
    bool showTapEffect = true,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: (style ?? const ButtonStyle()).copyWith(
            minimumSize:
                width != null || height != null ? MaterialStateProperty.all(Size((width ?? 64), (height ?? 52))) : null,
            side: color != null ? materialStateBorder(color, WtColors.gray3) : null,
            shape: borderRadius != null
                ? MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: borderRadius,
                    ),
                  )
                : null,
            splashFactory: showTapEffect ? null : NoSplash.splashFactory,
            padding: padding != null ? MaterialStateProperty.all<EdgeInsetsGeometry>(padding) : null,
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: child,
        );
}
