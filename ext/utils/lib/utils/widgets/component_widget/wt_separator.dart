import 'package:utils/utils.dart';

/// 패딩상관없이 구분선 추가하는 위젯
///
/// !!WtSeparator시 Builder 내부에서 패딩 사용(외부X)
class WtSeparator extends StatelessWidget {
  WtSeparator({
    super.key,
    Color? color,
    this.height = 8,
  }) : color = color ?? WtColors.gray4;

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: Center(
        child: OverflowBox(
          maxWidth: maxWidth,
          maxHeight: 8,
          child: Container(
            height: 8,
            width: double.infinity,
            color: color,
          ),
        ),
      ),
    );
  }
}
