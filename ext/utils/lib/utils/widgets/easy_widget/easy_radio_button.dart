import 'package:utils/utils.dart';

class EasyRadioButton<T> extends StatefulWidget {
  const EasyRadioButton({
    super.key,
    this.title,
    this.horizontalTitleGap,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.reverse = false,
  });

  /// 라디오버튼 타이틀
  final Widget? title;

  /// 버튼-타이틀간 간격 위젯
  final double? horizontalTitleGap;

  /// 라디오버튼 값
  final T value;

  /// 라디오버튼 그룹값
  final T? groupValue;

  /// 라디오버튼 변경 이벤트
  final ValueChanged<T?>? onChanged;

  final bool reverse;

  @override
  State<EasyRadioButton<T>> createState() => EasyRadioButtonState<T>();
}

class EasyRadioButtonState<T> extends State<EasyRadioButton<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onChanged != null ? onChanged : null,
      splashFactory: InkHighlightFactory(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null && widget.reverse == true) ...[
            widget.title!,
            SizedBox(width: widget.horizontalTitleGap ?? 8),
          ],
          IgnorePointer(
            ignoring: true,
            child: Radio<T>(
              value: widget.value,
              groupValue: widget.groupValue,
              onChanged: widget.onChanged != null ? (value) {} : null,
              visualDensity: const VisualDensity(horizontal: -4),
            ),
          ),
          if (widget.title != null && widget.reverse == false) ...[
            SizedBox(width: widget.horizontalTitleGap ?? 8),
            widget.title!,
          ],
        ],
      ),
    );
  }

  void onChanged() {
    if (widget.onChanged != null) widget.onChanged!(widget.value);
  }
}
