import 'package:utils/utils.dart';

class WtButtonModel {
  /// 버튼 텍스트
  final String buttonText;

  /// 버튼 텍스트
  final TextStyle? textStyle;

  /// 버튼 클릭 이벤트
  final void Function()? onPressed;

  WtButtonModel({
    required this.buttonText,
    this.textStyle,
    required this.onPressed,
  });
}

class WtTextButtonBar extends StatelessWidget {
  WtTextButtonBar.single({
    Key? key,
    required String buttonText,
    TextStyle? textStyle,
    required void Function()? onPressed,
    this.width,
    this.height = 40,
    Color? color,
  })  : color = color ?? WtColors.gray4,
        super(key: key) {
    buttonList = [
      WtButtonModel(
        buttonText: buttonText,
        textStyle: textStyle,
        onPressed: onPressed,
      )
    ];
  }

  // ignore: prefer_const_constructors_in_immutables
  WtTextButtonBar({
    super.key,
    required this.buttonList,
    this.width,
    this.height = 40,
    Color? color,
  }) : color = color ?? WtColors.gray4;

  late final List<WtButtonModel> buttonList;
  final double? width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: color,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SeparatedRow(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: buttonList.mapWithIndex(
          (buttonModel, index) {
            return Expanded(
              child: InkWell(
                onTap: buttonModel.onPressed,
                child: Center(
                  child: Text(
                    buttonModel.buttonText,
                    style: buttonModel.onPressed == null
                        ? WtTextStyle.bodyMedium.gray3
                        : buttonModel.textStyle ?? WtTextStyle.bodyMedium.onBack,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
        separatorBuilder: (context, index) {
          return Container(
            width: 1,
            height: 16,
            color: WtColors.gray3,
          );
        },
      ),
    );
  }
}
