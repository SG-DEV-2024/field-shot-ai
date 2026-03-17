import 'package:utils/utils.dart';

part 'easy_on_off_button.res.dart';

class EasyOnOffButton extends StatelessWidget {
  const EasyOnOffButton({
    Key? key,
    required this.onPressed,
    this.onOff = true,
    required this.type,
    this.blink,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final bool onOff;
  final EasyButtonType type;
  final double? blink;

  @override
  Widget build(BuildContext context) {
    var icon = _getButtonIcon();
    return ElevatedButton(
      onPressed: onPressed,
      style: _getButtonStyle(),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              sizedBox8,
            ],
            EasyText(_getButtonContent()),
          ],
        ),
      ),
    );
  }

  ButtonStyle? _getButtonStyle() {
    ButtonStyle? style;
    switch (type) {
      case EasyButtonType.onOffInterlock:
        style = _interlockButton;
        break;
      case EasyButtonType.onOffAnalysis:
        style = _analysisButton;
        break;
      case EasyButtonType.onOffDetail:
        style = _detailButton;
        break;
      case EasyButtonType.onOffLayoutMap:
        style = _layoutMapButton;
        break;
      case EasyButtonType.onOffLocationMap:
        style = _locationMapButton;
        break;
      case EasyButtonType.onOffReload:
        style = _reloadButton;
        break;
      case EasyButtonType.onOffConnecting:
        style = _connectingButton;
        break;
      default:
    }
    if (blink != null) {
      return style?.copyWith(
        backgroundColor: materialSolidColor(Color.lerp(WtColors.gray1, const Color(0xffEDB200), blink!)),
      );
    }
    return style;
  }

  Widget? _getButtonIcon() {
    switch (type) {
      case EasyButtonType.onOffInterlock:
      case EasyButtonType.onOffReload:
      case EasyButtonType.onOffConnecting:
        //xx return SvgPicture.asset('assets/svg/on_off_interlock.svg');
        return null;
      case EasyButtonType.onOffAnalysis:
        return null;
      case EasyButtonType.onOffDetail:
        //xx return SvgPicture.asset('assets/svg/on_off_detail.svg');
        return null;
      case EasyButtonType.onOffLayoutMap:
        //xx return SvgPicture.asset('assets/svg/on_off_layout_map.svg');
        return null;
      case EasyButtonType.onOffLocationMap:
        //xx return SvgPicture.asset('assets/svg/on_off_location_map.svg');
        return null;
      default:
    }
    return null;
  }

  String _getButtonContent() {
    switch (type) {
      case EasyButtonType.onOffInterlock:
        return '연동';
      case EasyButtonType.onOffAnalysis:
        return '촬영';
      case EasyButtonType.onOffDetail:
        return '상세';
      case EasyButtonType.onOffLayoutMap:
        return '건물 배치도';
      case EasyButtonType.onOffLocationMap:
        return '장비 위치도';
      case EasyButtonType.onOffReload:
        return '다시 시도';
      case EasyButtonType.onOffConnecting:
        return '다시 연결';
      default:
    }
    return '';
  }
}
