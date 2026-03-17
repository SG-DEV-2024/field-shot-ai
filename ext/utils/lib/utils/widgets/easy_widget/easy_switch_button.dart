import 'package:utils/utils.dart';

class EasySwitchButton<T> extends StatefulWidget {
  const EasySwitchButton({
    Key? key,
    this.initValue,
    required this.firstValue,
    required this.secondValue,
    required this.onChanged,
  }) : super(key: key);

  final T? initValue;
  final T firstValue;
  final T secondValue;
  final ValueChanged<T> onChanged;

  @override
  State<EasySwitchButton<T>> createState() => _EasySwitchButtonState<T>();
}

class _EasySwitchButtonState<T> extends State<EasySwitchButton<T>> {
  late T initValue;

  @override
  void initState() {
    super.initState();
    initValue = widget.initValue ?? widget.firstValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: WtColors.gray3, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          if (initValue == widget.firstValue) ...[
            _onButton(widget.firstValue),
            _offButton(widget.secondValue),
          ] else ...[
            _offButton(widget.firstValue),
            _onButton(widget.secondValue),
          ],
        ],
      ),
    );
  }

  Expanded _offButton(T value) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            initValue = value;
          });
          return widget.onChanged(value);
        },
        child: Center(
          child: Text(
            value.toString(),
            // style: WtTextStyle.size14B.grey2,
          ),
        ),
      ),
    );
  }

  Expanded _onButton(T value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: WtColors.background, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            value.toString(),
            // style: WtTextStyle.size14B.subBlue,
          ),
        ),
      ),
    );
  }
}
