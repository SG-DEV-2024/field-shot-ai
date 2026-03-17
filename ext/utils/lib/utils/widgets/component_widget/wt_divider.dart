import 'package:utils/utils.dart';

class WtDivider extends StatelessWidget {
  WtDivider({super.key, Color? color, this.height = 1})
      : padding = 0,
        color = color ?? WtColors.gray3;

  WtDivider.horizontal8({super.key, Color? color, this.height = 1})
      : padding = 8,
        color = color ?? WtColors.gray3;

  WtDivider.horizontal16({super.key, Color? color, this.height = 1})
      : padding = 16,
        color = color ?? WtColors.gray3;

  /// 패딩
  final double padding;

  /// 색상
  final Color color;

  /// 높이
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Divider(
        color: color,
        height: height,
        thickness: 1,
      ),
    );
  }
}

class WtFullDivider extends StatelessWidget {
  WtFullDivider({
    Key? key,
    this.height = 16.0,
    this.thickness = 1,
    Color? color,
  })  : color = color ?? WtColors.gray3,
        super(key: key);

  final double height;
  final double? thickness;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: OverflowBox(
          maxWidth: MediaQuery.of(context).size.width,
          child: Divider(
            color: color,
            height: height,
            thickness: thickness,
          ),
        ),
      );
}

class WtVerticalDivider extends StatelessWidget {
  WtVerticalDivider({super.key, Color? color, this.width = 1, this.height = 16})
      : padding = 0,
        color = color ?? WtColors.gray3;

  WtVerticalDivider.vertical8({super.key, Color? color, this.width = 1, this.height = 16})
      : padding = 8,
        color = color ?? WtColors.gray3;

  WtVerticalDivider.vertical16({super.key, Color? color, this.width = 1, this.height = 16})
      : padding = 16,
        color = color ?? WtColors.gray3;

  /// 패딩
  final double padding;

  /// 색상
  final Color color;

  /// 크기
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: SizedBox(
        height: height,
        child: VerticalDivider(
          color: color,
          width: width,
          thickness: 1,
        ),
      ),
    );
  }
}
