import 'package:utils/utils.dart';

class EasyCheckButton extends StatefulWidget {
  const EasyCheckButton({
    super.key,
    this.horizontalTitleGap,
    this.title,
    this.initValue = false,
    required this.onChanged,
    this.reverse = false,
  });

  final Widget? title;
  final double? horizontalTitleGap;
  final bool initValue;
  final ValueChanged<bool>? onChanged;
  final bool reverse;

  @override
  EasyCheckButtonState createState() => EasyCheckButtonState();
}

class EasyCheckButtonState extends State<EasyCheckButton> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: WtTextStyle.labelLarge.onPrimaryContainer,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null && widget.reverse == true) ...[
            GestureDetector(
              onTap: onChanged,
              behavior: HitTestBehavior.translucent,
              child: EasyConstraints(
                height: 40.0,
                padding: EdgeInsets.only(right: widget.horizontalTitleGap ?? 8.0),
                child: widget.title!,
              ),
            ),
          ],
          Checkbox(
            value: value,
            onChanged: widget.onChanged != null ? (_) => onChanged() : null,
            visualDensity: const VisualDensity(horizontal: -4),
          ),
          if (widget.title != null && widget.reverse == false) ...[
            GestureDetector(
              onTap: onChanged,
              behavior: HitTestBehavior.translucent,
              child: EasyConstraints(
                height: 40.0,
                padding: EdgeInsets.only(left: widget.horizontalTitleGap ?? 8.0),
                child: widget.title!,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void onChanged() {
    setState(() => value = !value);
    if (widget.onChanged != null) widget.onChanged!(value);
  }
}
