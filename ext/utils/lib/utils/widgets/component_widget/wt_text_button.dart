import 'package:utils/utils.dart';

class WtTextButton extends TextButton {
  WtTextButton({
    Key? key,
    double? width,
    double? height,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required Widget child,
    bool showTapEffect = false,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: (style ?? const ButtonStyle()).copyWith(
              minimumSize: width != null || height != null
                  ? MaterialStateProperty.all(Size((width ?? 64), (height ?? 48)))
                  : null,
              splashFactory: showTapEffect ? null : NoSplash.splashFactory),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: child,
        );
  // * minimumSize는 테마에서 가져온 값을 기본으로 사용합니다.
}

class WtTextButtonWithIcon extends StatelessWidget {
  WtTextButtonWithIcon({
    super.key,
    double? width,
    double? height,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required Widget icon,
    required Widget label,
    bool showTapEffect = false,
  }) : _widget = TextButton.icon(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: (style ?? const ButtonStyle()).copyWith(
              minimumSize: width != null || height != null
                  ? MaterialStateProperty.all(Size((width ?? 64), (height ?? 48)))
                  : null,
              splashFactory: showTapEffect ? null : NoSplash.splashFactory),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          icon: icon,
          label: label,
        );

  final Widget _widget;

  @override
  Widget build(BuildContext context) => _widget;
}
