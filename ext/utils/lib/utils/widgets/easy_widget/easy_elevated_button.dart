import 'package:utils/utils.dart';

part 'easy_elevated_button.res.dart';

class EasyElevatedButton extends StatelessWidget {
  const EasyElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.type = EasyButtonType.main,
    this.expand,
    this.backgroundColor, //xx Device를 위한 잠시 사용되는 값들입니다.
  });

  final VoidCallback? onPressed;
  final dynamic child;
  final Widget? icon;
  final EasyButtonType type;
  final bool? expand;
  final Color? backgroundColor; //xx Device를 위한 잠시 사용되는 값들입니다.

  @override
  Widget build(BuildContext context) {
    if (expand == true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_elevatedButton()],
      );
    } else {
      return _elevatedButton();
    }
  }

  _elevatedButton() {
    final label = child is Widget ? child : Text(child.toString());
    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: _getButtonStyle(),
        icon: icon!,
        label: label,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: _getButtonStyle(),
        child: label,
      );
    }
  }

  ButtonStyle? _getButtonStyle() {
    ButtonStyle? style;
    switch (type) {
      case EasyButtonType.warning:
        style = _subRedButton;
        break;
      case EasyButtonType.subRed:
        style = _subRedButton;
        break;
      case EasyButtonType.small:
        style = _smallButton;
        break;
      //xx Device를 위한 잠시 사용되는 값들입니다.
      case EasyButtonType.color:
        style = _colorButton(backgroundColor);
        break;
      case EasyButtonType.square:
        style = _squareButton;
        break;
      case EasyButtonType.squareDim:
        style = _squareDimButton;
        break;
      case EasyButtonType.minimum:
        style = _minimumButton;
        break;
      default:
    }
    return style;
  }
}
