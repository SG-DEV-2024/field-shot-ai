import 'package:utils/utils.dart';

part 'easy_outlined_button.res.dart';

class EasyOutlinedButton extends StatelessWidget {
  const EasyOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.type = EasyButtonType.main,
    this.expand,
  });

  final VoidCallback? onPressed;
  final dynamic child;
  final Widget? icon;
  final EasyButtonType type;
  final bool? expand;

  @override
  Widget build(BuildContext context) {
    if (expand == true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_outlinedButton()],
      );
    } else {
      return _outlinedButton();
    }
  }

  Widget _outlinedButton() {
    final label = child is Widget ? child : Text(child.toString());
    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: _getButtonStyle(),
        icon: icon!,
        label: label,
      );
    } else {
      return OutlinedButton(
        onPressed: onPressed,
        style: _getButtonStyle(),
        child: label,
      );
    }
  }

  ButtonStyle? _getButtonStyle() {
    return switch (type) {
      EasyButtonType.error => _errorStyle,
      EasyButtonType.small => _smallStyle,
      EasyButtonType.errorSmall => _errorStyle.merge(_smallStyle),
      EasyButtonType.primaryContainer => _primaryContainerStyle,
      EasyButtonType.primaryContainerSmall => _primaryContainerStyle.merge(_smallStyle),
      EasyButtonType.secondaryContainer => _secondaryContainerStyle,
      EasyButtonType.tertiaryContainer => _tertiaryContainerStyle,
      //xx Device를 위한 잠시 사용되는 값들입니다.
      EasyButtonType.minimum => _minimumButton,
      //* 지원N
      EasyButtonType.osMain => _osMainStyle(),
      EasyButtonType.osError => _osErrorStyle(),
      EasyButtonType.osDialog => _osMainStyle(width: 110.0),
      _ => null
    };
  }
}
