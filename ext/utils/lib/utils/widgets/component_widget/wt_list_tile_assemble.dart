import 'package:utils/utils.dart';

class WtListTileAssemble extends StatelessWidget {
  const WtListTileAssemble({
    super.key,
    this.leading,
    this.bodyTop,
    this.bodyBottom,
    this.onTap,
    this.showTapEffect = true,
    this.padding = EdgeInsets.zero,
    this.leadingBodyGap = 8,
    this.bodyTrailingGap = 8,
    this.trailingTop,
    this.trailingBottom,
  });

  /// 전열 위젯
  final Widget? leading;

  /// 바디(위)
  final Widget? bodyTop;

  /// 바디(아래)
  final Widget? bodyBottom;

  /// 클릭이벤트
  final VoidCallback? onTap;

  /// 클릭 이펙트 여부
  final bool showTapEffect;

  /// 패딩
  final EdgeInsetsGeometry padding;

  /// 후열 위젯(위)
  final Widget? trailingTop;

  /// 후열 위젯(아래)
  final Widget? trailingBottom;

  /// leading - body 갭 사이즈
  final double leadingBodyGap;

  /// body - trailing 갭 사이즈
  final double bodyTrailingGap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: showTapEffect ? null : Colors.transparent,
      highlightColor: showTapEffect ? null : Colors.transparent,
      splashColor: showTapEffect ? null : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: padding,
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(
                  width: leadingBodyGap,
                ),
              ] else ...[
                Container(
                  width: 48,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: const Center(
                    child: Text('1'),
                  ),
                ),
                Container(
                  color: Colors.green,
                  width: leadingBodyGap,
                ),
              ],
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: bodyTop == null
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                  ),
                                  child: const Center(
                                    child: Text('2'),
                                  ),
                                )
                              : bodyTop!,
                        ),
                        if (trailingTop != null) ...[
                          const SizedBox(width: 8),
                          trailingTop!
                        ] else ...[
                          Container(
                            color: Colors.blue,
                            width: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all(width: 1)),
                            child: const Center(
                              child: Text('3'),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: bodyBottom == null
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                  ),
                                  child: const Center(
                                    child: Text('4'),
                                  ),
                                )
                              : bodyBottom!,
                        ),
                        if (trailingBottom != null) ...[
                          const SizedBox(width: 8),
                          trailingBottom!
                        ] else ...[
                          Container(
                            color: Colors.yellow,
                            width: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: const Center(child: Text('5')),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
