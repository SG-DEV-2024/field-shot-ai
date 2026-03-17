import 'package:flutter/material.dart';
import 'ignore.dart';

/// 패딩 무시하는 경우 사용 할 위젯
///
/// Column을 감싸서 사용
///
/// 무시할 자식위젯 Ignore위젯으로 제어
class IgnorePadding extends StatelessWidget {
  const IgnorePadding({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Column child;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    Column rebuildWidget;

    rebuildWidget = Column(
      crossAxisAlignment: child.crossAxisAlignment,
      key: child.key,
      mainAxisAlignment: child.mainAxisAlignment,
      mainAxisSize: child.mainAxisSize,
      textBaseline: child.textBaseline,
      textDirection: child.textDirection,
      verticalDirection: child.verticalDirection,
      children: (child.children).map((widget) {
        if (widget is Ignore || widget is Expanded || widget is Flexible) {
          return widget;
        } else {
          return Padding(
            padding: padding,
            child: widget,
          );
        }
      }).toList(),
    );

    return rebuildWidget;
  }
}
