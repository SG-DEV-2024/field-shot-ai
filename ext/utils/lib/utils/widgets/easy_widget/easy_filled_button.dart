import 'package:utils/utils.dart';

part 'easy_filled_button.res.dart';

class EasyFilledButton extends StatelessWidget {
  const EasyFilledButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    required this.child,
    this.icon,
    this.type = EasyButtonType.main,
    this.tonal = false,
    this.expand,
  });

  const EasyFilledButton.tonal({
    super.key,
    required this.onPressed,
    this.onLongPress,
    required this.child,
    this.icon,
    this.type = EasyButtonType.main,
    this.tonal = true,
    this.expand,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final dynamic child;
  final Widget? icon;
  final EasyButtonType type;
  final bool tonal;
  final bool? expand;

  @override
  Widget build(BuildContext context) {
    if (expand == true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_filledButton()],
      );
    } else {
      return _filledButton();
    }
  }

  Widget _filledButton() {
    final label = child is Widget ? child : Text(child.toString());
    if (tonal) {
      if (icon != null) {
        return FilledButton.tonalIcon(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: _getButtonStyle(),
          icon: icon!,
          label: label,
        );
      } else {
        return FilledButton.tonal(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: _getButtonStyle(),
          child: label,
        );
      }
    } else {
      if (icon != null) {
        return FilledButton.icon(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: _getButtonStyle(),
          icon: icon!,
          label: label,
        );
      } else {
        return FilledButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: _getButtonStyle(),
          child: label,
        );
      }
    }
  }

  ButtonStyle? _getButtonStyle() {
    return switch (type) {
      EasyButtonType.small => _smallStyle,
      EasyButtonType.select => _selectStyle,
      EasyButtonType.selectSmall => _selectSmallStyle,
      EasyButtonType.secondary => tonal ? _secondaryTonal : _secondaryStyle,
      EasyButtonType.tertiary => tonal ? _tertiaryTonal : _tertiaryStyle,
      EasyButtonType.error => tonal ? _errorTonal : _errorStyle,
      EasyButtonType.errorSmall => tonal ? _errorTonal.merge(_smallStyle) : _errorStyle.merge(_smallStyle),
      //xx 옥유아이 되는데로 넣은 것
      EasyButtonType.largeMain => _largeMainStyle,
      //* 지원N
      EasyButtonType.osMain => _osMainStyle(),
      EasyButtonType.osDialog => _osMainStyle(width: 110.0),
      EasyButtonType.osExtension => _osMainStyle(width: 217.0, height: 77),
      EasyButtonType.osSmall => _osSmallStyle(),
      EasyButtonType.osTiny => _osTinyStyle(),
      _ => null,
    };
  }
}
