import 'package:utils/utils.dart';

/// Expanded가 사용되는 SingleChildScrollView 위젯
class WtSingleChildScrollView extends StatelessWidget {
  const WtSingleChildScrollView({
    super.key,
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.padding,
    this.physics,
    this.primary,
    this.restorationId,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.child,
    this.blankSize = 0,
    this.blankStart,
    this.blankEnd,
  });

  final Widget? child;
  final Clip clipBehavior;
  final ScrollController? controller;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool? primary;
  final String? restorationId;
  final bool reverse;
  final Axis scrollDirection;
  final double blankSize;
  final double? blankStart;
  final double? blankEnd;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowIndicator();
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          EdgeInsetsGeometry insidePadding = (padding ?? EdgeInsets.zero).add(blankStart != null || blankEnd != null
              ? (scrollDirection == Axis.vertical
                  ? EdgeInsets.only(top: blankStart ?? 0, bottom: blankEnd ?? 0)
                  : EdgeInsets.only(left: blankStart ?? 0, right: blankEnd ?? 0))
              : (scrollDirection == Axis.vertical
                  ? EdgeInsets.symmetric(vertical: blankSize)
                  : EdgeInsets.symmetric(horizontal: blankSize)));

          return SingleChildScrollView(
            clipBehavior: clipBehavior,
            controller: controller,
            dragStartBehavior: dragStartBehavior,
            key: key,
            keyboardDismissBehavior: keyboardDismissBehavior,
            padding: padding,
            physics: physics,
            primary: primary,
            restorationId: restorationId,
            reverse: reverse,
            scrollDirection: scrollDirection,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: insidePadding,
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
