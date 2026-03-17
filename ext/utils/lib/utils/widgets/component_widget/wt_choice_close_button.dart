import 'package:utils/utils.dart';

class WtChoiceCloseButton<T> extends StatelessWidget {
  WtChoiceCloseButton({
    Key? key,
    required this.buttonList,
    this.enumStrList = const [],
    required this.onChanged,
    this.showCloseButton = false,
  }) : super(key: key);

  final List<T> buttonList;
  final List<String> enumStrList;
  final Function(List<T> valueList) onChanged;
  final bool showCloseButton;
  late final _buttonList = ValueNotifier<List<T>>(buttonList);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
        valueListenable: _buttonList,
        builder: (context, list, _) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: list
                .mapWithIndex(
                  (title, index) => getButtonWidget(getTitleString(title, index), index),
                )
                .toList(),
          );
        });
  }

  String getTitleString(T title, int index) {
    if (title is Enum) {
      if (buttonList.length == enumStrList.length) {
        return enumStrList[index];
      } else {
        return title.name;
      }
    } else {
      return title.toString();
    }
  }

  Widget getButtonWidget(String title, int index) {
    return InkWell(
      onTap: () {
        _buttonList.value = List.of(_buttonList.value)..removeAt(index);
        // ignore: void_checks
        return onChanged(_buttonList.value);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: WtColors.primaryContainer,
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: WtTextStyle.labelLarge.back),
            if (showCloseButton) ...[
              const SizedBox(
                width: 6,
              ),
              Icon(WtIcons.close_s, size: 14, color: WtColors.background)
            ],
          ],
        ),
      ),
    );
  }
}
