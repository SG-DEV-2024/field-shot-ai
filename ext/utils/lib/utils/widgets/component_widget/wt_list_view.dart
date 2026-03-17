import 'package:utils/utils.dart';

enum _WtListViewKind {
  rare,
  builder,
  custom,
  separated,
}

class WtListView extends StatelessWidget {
  WtListView({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.children = const <Widget>[],
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.blankSize = 0,
    this.blankStart,
    this.blankEnd,
  })  : itemBuilder = null,
        separatorBuilder = null,
        itemCount = null,
        childrenDelegate = null,
        _kind = _WtListViewKind.rare,
        _localPadding = (padding ?? EdgeInsets.zero).add(blankStart != null || blankEnd != null
            ? (scrollDirection == Axis.vertical
                ? EdgeInsets.only(top: blankStart ?? 0, bottom: blankEnd ?? 0)
                : EdgeInsets.only(left: blankStart ?? 0, right: blankEnd ?? 0))
            : (scrollDirection == Axis.vertical
                ? EdgeInsets.symmetric(vertical: blankSize)
                : EdgeInsets.symmetric(horizontal: blankSize))),
        super(key: key);

  WtListView.builder({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    required this.itemBuilder,
    this.itemCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.blankSize = 0,
    this.blankStart,
    this.blankEnd,
  })  : separatorBuilder = null,
        childrenDelegate = null,
        children = null,
        _kind = _WtListViewKind.builder,
        _localPadding = (padding ?? EdgeInsets.zero).add(blankStart != null || blankEnd != null
            ? (scrollDirection == Axis.vertical
                ? EdgeInsets.only(top: blankStart ?? 0, bottom: blankEnd ?? 0)
                : EdgeInsets.only(left: blankStart ?? 0, right: blankEnd ?? 0))
            : (scrollDirection == Axis.vertical
                ? EdgeInsets.symmetric(vertical: blankSize)
                : EdgeInsets.symmetric(horizontal: blankSize))),
        super(key: key);

  WtListView.custom({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    required this.childrenDelegate,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.blankSize = 0,
    this.blankStart,
    this.blankEnd,
  })  : itemBuilder = null,
        separatorBuilder = null,
        itemCount = null,
        addAutomaticKeepAlives = true,
        addRepaintBoundaries = true,
        addSemanticIndexes = true,
        children = null,
        _kind = _WtListViewKind.custom,
        _localPadding = (padding ?? EdgeInsets.zero).add(blankStart != null || blankEnd != null
            ? (scrollDirection == Axis.vertical
                ? EdgeInsets.only(top: blankStart ?? 0, bottom: blankEnd ?? 0)
                : EdgeInsets.only(left: blankStart ?? 0, right: blankEnd ?? 0))
            : (scrollDirection == Axis.vertical
                ? EdgeInsets.symmetric(vertical: blankSize)
                : EdgeInsets.symmetric(horizontal: blankSize))),
        super(key: key);

  WtListView.separated({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.itemCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.blankSize = 0,
    this.blankStart,
    this.blankEnd,
  })  : itemExtent = null,
        prototypeItem = null,
        dragStartBehavior = DragStartBehavior.start,
        childrenDelegate = null,
        children = null,
        semanticChildCount = null,
        _kind = _WtListViewKind.separated,
        _localPadding = (padding ?? EdgeInsets.zero).add(blankStart != null || blankEnd != null
            ? (scrollDirection == Axis.vertical
                ? EdgeInsets.only(top: blankStart ?? 0, bottom: blankEnd ?? 0)
                : EdgeInsets.only(left: blankStart ?? 0, right: blankEnd ?? 0))
            : (scrollDirection == Axis.vertical
                ? EdgeInsets.symmetric(vertical: blankSize)
                : EdgeInsets.symmetric(horizontal: blankSize))),
        super(key: key);

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final Widget? prototypeItem;
  final Widget Function(BuildContext, int)? itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final int? itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SliverChildDelegate? childrenDelegate;
  final double? cacheExtent;
  final List<Widget>? children;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final double blankSize;
  final double? blankStart;
  final double? blankEnd;

  final _WtListViewKind _kind;
  final EdgeInsetsGeometry _localPadding;

  @override
  Widget build(BuildContext context) {
    switch (_kind) {
      case _WtListViewKind.rare:
        return _buildRare(context);
      case _WtListViewKind.builder:
        return _buildBuilder(context);
      case _WtListViewKind.custom:
        return _buildCustom(context);
      case _WtListViewKind.separated:
        return _buildSeparated(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRare(BuildContext context) => NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: _localPadding,
          itemExtent: itemExtent,
          prototypeItem: prototypeItem,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          children: children!,
        ).scrollEffectOff(),
      );

  Widget _buildBuilder(BuildContext context) => NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView.builder(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: _localPadding,
          itemExtent: itemExtent,
          prototypeItem: prototypeItem,
          itemBuilder: itemBuilder!,
          itemCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        ).scrollEffectOff(),
      );

  Widget _buildCustom(BuildContext context) => NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView.custom(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: _localPadding,
          itemExtent: itemExtent,
          prototypeItem: prototypeItem,
          childrenDelegate: childrenDelegate!,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        ).scrollEffectOff(),
      );

  Widget _buildSeparated(BuildContext context) => NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView.separated(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: _localPadding,
          itemBuilder: itemBuilder!,
          separatorBuilder: separatorBuilder!,
          itemCount: itemCount!,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        ).scrollEffectOff(),
      );
}
