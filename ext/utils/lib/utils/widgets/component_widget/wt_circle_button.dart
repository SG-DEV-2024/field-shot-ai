import 'package:utils/utils.dart';

class WtCircleButton extends StatelessWidget {
  const WtCircleButton({
    Key? key,
    required this.value,
    required this.title,
    this.showCloseButton = false,
  }) : super(key: key);

  final bool value;
  final String title;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        value
            ? Container(
                width: 58,
                height: 24,
                decoration: BoxDecoration(
                  color: WtColors.primaryContainer,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: WtColors.gray2),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: WtTextStyle.bodySmall.back,
                  ),
                ),
              )
            : Container(
                width: 58,
                height: 24,
                decoration: BoxDecoration(
                  color: WtColors.gray4,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: WtColors.gray2),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: WtTextStyle.bodySmall.onBack,
                  ),
                ),
              ),
      ],
    );
  }
}
