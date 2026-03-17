import 'package:utils/utils.dart';

class WtBadge extends StatelessWidget {
  const WtBadge({Key? key, required this.count}) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    String textCount = _getTextCount(count);

    return count == 0
        ? const SizedBox.shrink()
        : Container(
            width: 7 + (textCount.length * 7),
            height: 14,
            decoration: BoxDecoration(
              color: WtColors.error,
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            padding: const EdgeInsets.only(top: 1, left: 0.5),
            child: Center(
              child: Text(
                textCount,
                // style: WtTextStyle.size10.white,
              ),
            ),
          );
  }

  String _getTextCount(int count) {
    if (count <= 99) {
      return count.toString();
    } else {
      return '99+';
    }
  }
}
