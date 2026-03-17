import 'package:utils/utils.dart';

class WtExpansionTile extends StatefulWidget {
  const WtExpansionTile(
      {Key? key,
      required this.title,
      this.headerPadding,
      this.headerBackgroundColor,
      this.body,
      this.bodyPadding,
      this.bodyBackgroundColor,
      this.iconData = WtIcons.expand_less,
      this.initiallyExpanded = false,
      this.showTapEffect = true,
      this.onChanged})
      : super(key: key);

  /// 타이틀 위젯(좌측)
  final Widget title;

  /// 헤더패딩 기본:EdgeInsets.symmetric(horizontal: 16),
  final EdgeInsetsGeometry? headerPadding;

  /// 헤더 배경 생상
  final Color? headerBackgroundColor;

  /// 확장시 표시되는 바디부분
  final Widget? body;

  /// 바디패딩 기본:EdgeInsets.all(16),
  final EdgeInsetsGeometry? bodyPadding;

  /// 바디 배경 색상
  final Color? bodyBackgroundColor;

  /// 아이콘 데이터(우측)
  final IconData iconData;

  /// 초기 확장 여부
  final bool? initiallyExpanded;

  /// 탭 이펙트 여부
  final bool showTapEffect;

  /// 확장시 이벤트
  final ValueChanged<bool>? onChanged;

  @override
  State<WtExpansionTile> createState() => _WtExpansionTileState();
}

class _WtExpansionTileState extends State<WtExpansionTile> with TickerProviderStateMixin {
  final Tween<double> turnsTween = Tween<double>(
    begin: 0,
    end: 0.5,
  );

  late Animation<double> animation;
  late AnimationController _controller;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _isExpanded = widget.initiallyExpanded ?? false;
    if (_isExpanded) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: widget.showTapEffect ? null : Colors.transparent,
      hoverColor: widget.showTapEffect ? null : Colors.transparent,
      splashColor: widget.showTapEffect ? null : Colors.transparent,
      onTap: () {
        if (_isExpanded) {
          _controller.reverse(); //닫기
        } else {
          _controller.forward(); //열기
        }
        _isExpanded = !_isExpanded;
        if (widget.onChanged != null) return widget.onChanged!(_isExpanded);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: widget.headerPadding ?? const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints(minHeight: 56),
            color: widget.headerBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: widget.title,
                ),
                RotationTransition(
                  turns: turnsTween.animate(_controller),
                  child: Icon(
                    widget.iconData,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: animation,
            child: Container(
              color: widget.bodyBackgroundColor,
              alignment: Alignment.center,
              padding: widget.bodyPadding ?? const EdgeInsets.all(16),
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }
}
