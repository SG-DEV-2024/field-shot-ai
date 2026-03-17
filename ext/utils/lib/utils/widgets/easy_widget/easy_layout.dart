import 'package:utils/utils.dart';

class EasyColumn extends StatelessWidget {
  const EasyColumn({
    Key? key,
    this.formKey,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.bottom = true,
    this.vertical = 16.0,
    this.horizontal = 16.0,
    this.children = const <Widget>[],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  }) : super(key: key);

  final Key? formKey;
  final AutovalidateMode autovalidateMode;
  final bool bottom;
  final double? vertical;
  final double? horizontal;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: bottom,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              horizontal ?? 0.0, vertical ?? 0.0, horizontal ?? 0.0, bottom ? vertical ?? 0.0 : 0.0),
          child: formKey != null
              ? Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    mainAxisAlignment: mainAxisAlignment,
                    mainAxisSize: mainAxisSize,
                    crossAxisAlignment: crossAxisAlignment,
                    children: children,
                  ),
                )
              : Column(
                  mainAxisAlignment: mainAxisAlignment,
                  mainAxisSize: mainAxisSize,
                  crossAxisAlignment: crossAxisAlignment,
                  children: children,
                ),
        ),
      );
}

class EasyScrollView extends StatelessWidget {
  const EasyScrollView({
    Key? key,
    this.formKey,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.edge = Edge.none,
    this.padding,
    this.bottom = true,
    // this.vertical = 16.0,
    // this.horizontal = 16.0,
    this.limitRight,
    this.primary,
    this.physics,
    this.controller,
    this.children = const <Widget>[],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  }) : super(key: key);

  final Key? formKey;
  final AutovalidateMode autovalidateMode;
  final Edge edge;
  final EdgeInsetsGeometry? padding;
  final bool bottom;
  // final double? vertical;
  // final double? horizontal;
  final double? limitRight;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: bottom,
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Scrollbar(
            controller: controller,
            child: SingleChildScrollView(
              padding: edge == Edge.none ? padding : edge.calc(limitRight),
              primary: primary,
              physics: physics,
              controller: controller,
              child: Column(
                mainAxisAlignment: mainAxisAlignment,
                mainAxisSize: mainAxisSize,
                crossAxisAlignment: crossAxisAlignment,
                children: children,
              ),
            ),
          ),
        ),
      );
}

class EasyExpanded extends StatelessWidget {
  const EasyExpanded({
    Key? key,
    this.flex = 1,
    required this.child,
    this.alignment = Alignment.topCenter,
    this.padding,
    this.margin,
  }) : super(key: key);

  final int flex;
  final Widget child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => Expanded(
        flex: flex,
        child: Container(
          alignment: alignment,
          padding: padding,
          margin: margin,
          color: isTestMode ? WtColors.secondary.withOpacity(0.05) : null,
          child: child,
        ),
      );
}
