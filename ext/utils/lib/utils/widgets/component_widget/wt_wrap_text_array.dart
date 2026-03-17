import 'package:utils/utils.dart';

class WtWrapTextArray extends StatelessWidget {
  const WtWrapTextArray({
    Key? key,
    required this.array,
    this.style,
    this.spacingWidth = 8,
    this.spacingHeight = 8,
    this.isComma = true,
  }) : super(key: key);
  final List<String> array;
  final TextStyle? style;
  final double spacingWidth;
  final double spacingHeight;

  /// WrapAlignment 를 배치하여 정렬을 해봅니다. - 그러나 이 위젯을 몇군데만 사용한다면 굳이 완벽하게 작성할 필요는 없고, 통일된 커스터마이징
  final bool isComma;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacingWidth,
      runSpacing: spacingHeight,
      children: array
          .mapWithIndex<Widget>(
            (str, index) => Text(
              str + (isComma && index < array.length - 1 ? ',' : ''),
              style: style,
            ),
          )
          .toList(),
    );
  }
}
