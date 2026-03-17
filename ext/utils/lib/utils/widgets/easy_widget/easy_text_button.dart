import 'package:utils/utils.dart';

part 'easy_text_button.res.dart';

class EasyTextButton extends StatelessWidget {
  EasyTextButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.child,
    this.type = EasyButtonType.osMain,
    // ignore: empty_constructor_bodies
  }) {}

  final VoidCallback? onPressed;
  final Widget? icon;
  final dynamic child;
  final EasyButtonType type;

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? TextButton.icon(
            onPressed: onPressed,
            style: _getButtonStyle(),
            icon: icon!,
            label: child is Widget ? child : EasyText(child.toString()),
          )
        : TextButton(
            onPressed: onPressed,
            style: _getButtonStyle(),
            child: child is Widget ? child : EasyText(child.toString()),
          );
  }

  ButtonStyle? _getButtonStyle() => switch (type) {
        EasyButtonType.warning => _warningButton,
        //* 지원N
        _ => _osMainButton,
      };
}
