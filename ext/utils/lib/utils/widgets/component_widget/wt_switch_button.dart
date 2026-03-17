import 'package:utils/utils.dart';

class WtSwitchButton<T> extends StatefulWidget {
  const WtSwitchButton({
    Key? key,
    this.initValue,
    required this.firstValue,
    required this.secondValue,
    this.thirdValue,
    this.fourthValue,
    this.fifthValue,
    required this.onChanged,
  }) : super(key: key);

  final T? initValue;
  final T firstValue;
  final T secondValue;
  final T? thirdValue;
  final T? fourthValue;
  final T? fifthValue;
  final ValueChanged<T> onChanged;

  @override
  State<WtSwitchButton<T>> createState() => _WtSwitchButtonState<T>();
}

class _WtSwitchButtonState<T> extends State<WtSwitchButton<T>> {
  T? initValue;

  @override
  void initState() {
    super.initState();
    initValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: Row(
        children: [
          _button(widget.firstValue, initValue == widget.firstValue),
          sizedBox6,
          _button(widget.secondValue, initValue == widget.secondValue),
          if (widget.thirdValue != null) ...[
            sizedBox6,
            _button(widget.thirdValue as T, initValue == widget.thirdValue),
          ],
          if (widget.fourthValue != null) ...[
            sizedBox6,
            _button(widget.fourthValue as T, initValue == widget.fourthValue),
          ],
          if (widget.fifthValue != null) ...[
            sizedBox6,
            _button(widget.fifthValue as T, initValue == widget.fifthValue),
          ],
        ],
      ),
    );
  }

  Widget _button(T value, bool? on) {
    if (on == true) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(color: WtColors.primary, borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              value.toString(),
              style: WtTextStyle.labelMedium.back,
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: InkWell(
          onTap: () {
            setState(() {
              initValue = value;
            });
            return widget.onChanged(value);
          },
          child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: WtColors.primary)),
            child: Center(
              child: Text(
                value.toString(),
                style: WtTextStyle.labelMedium.primary,
              ),
            ),
          ),
        ),
      );
    }
  }
}
