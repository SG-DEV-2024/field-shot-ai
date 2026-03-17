import 'package:utils/utils.dart';

typedef GestureBoolCallback = void Function(bool selected);

class WtRectangleButton extends StatelessWidget {
  WtRectangleButton({
    Key? key,
    required this.title,
    bool initValue = false,
    this.onPressed,
    this.showCloseButton = false,
    this.width,
    this.height,
    this.padding,
    this.textColor,
  })  : nValue = ValueNotifier<bool>(initValue),
        super(key: key);

  final ValueNotifier<bool> nValue;
  final String title;
  final bool showCloseButton;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final GestureBoolCallback? onPressed;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: nValue,
      builder: (context, value, child) {
        final btnColor = value ? WtColors.primaryContainer : WtColors.gray4;
        final textStyle = value ? WtTextStyle.labelLarge.back : WtTextStyle.labelLarge.gray2.copyWith(color: textColor);
        final autoSize = width == null && height == null;

        return Align(
          child: InkWell(
            onTap: () {
              nValue.value = !value;
              if (onPressed != null) onPressed!(nValue.value);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: autoSize ? 34 : height,
              decoration: BoxDecoration(
                color: btnColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                  if (showCloseButton) ...[
                    const SizedBox(width: 6),
                    Icon(WtIcons.close_s, size: 14, color: WtColors.background)
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/*
class WtRectangleButton extends StatelessWidget {
  const WtRectangleButton(
      {Key? key,
      required this.value,
      required this.title,
      this.onTap,
      this.showCloseButton = false})
      : super(key: key);

  final bool value;
  final String title;
  final bool showCloseButton;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return value
        ? Align(
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: 42,
                height: 34,
                decoration: BoxDecoration(
                  color: WtColors.indigo,
                ),
                child: Center(
                  child: Text(
                    title,
                    style: WtTextStyle.size14M.white,
                  ),
                ),
              ),
            ),
          )
        : Align(
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: 42,
                height: 34,
                decoration: BoxDecoration(
                  color: WtColors.grey5,
                ),
                child: Center(
                  child: Text(
                    title,
                    style: WtTextStyle.size14M.grey1,
                  ),
                ),
              ),
            ),
          );
  }
}
*/

