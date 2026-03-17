import 'package:utils/utils.dart';

class WtTextOverflow extends StatefulWidget {
  @override
  EditorState createState() => EditorState();

  const WtTextOverflow({
    Key? key,
    required this.text,
    this.textStyle,
    this.maxLines = 2,
  }) : super(key: key);

  final String text;
  final TextStyle? textStyle;
  final int? maxLines;
}

class EditorState extends State<WtTextOverflow> {
  late int? _maxLines;

  @override
  void initState() {
    super.initState();
    _maxLines = widget.maxLines ?? 2;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      // Build the textspan
      var span = TextSpan(
        text: widget.text,
        style: widget.textStyle,
      );

      // Use a textpainter to determine if it will exceed max lines
      var tp = TextPainter(
        maxLines: _maxLines,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
        text: span,
      );

      // trigger it to layout
      tp.layout(maxWidth: size.maxWidth);

      // whether the text overflowed or not
      var isOverFlow = tp.didExceedMaxLines;

      return isOverFlow
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  span,
                  overflow: TextOverflow.fade, // TextOverflow.ellipsis은 web에서 버그 발생!
                  maxLines: _maxLines,
                  style: widget.textStyle ?? WtTextStyle.bodyLarge.onBack,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _maxLines = null;
                        });
                      },
                      child: Text(
                        '더보기',
                        style: WtTextStyle.bodyMedium.gray2,
                      ),
                    ),
                  ),
                )
              ],
            )
          : Text.rich(
              span,
              style: widget.textStyle ?? WtTextStyle.bodyLarge.onBack,
            );
    });
  }
}
