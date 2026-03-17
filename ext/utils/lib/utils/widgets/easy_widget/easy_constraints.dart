import 'package:utils/utils.dart';

class EasyConstraints extends StatelessWidget {
  const EasyConstraints({
    Key? key,
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.alignment,
    this.padding,
    this.margin,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.child,
  }) : //alignment = alignment ?? Alignment.centerLeft,
        super(key: key);

  final double? width;
  final double? height;
  final double? maxWidth;
  final double? maxHeight;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(
            minWidth: width ?? 0,
            minHeight: height ?? 0,
            maxWidth: maxWidth ?? double.infinity,
            maxHeight: maxHeight ?? double.infinity),
        decoration: borderRadius != null || borderColor != null
            ? BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius ?? 4.0),
                border: borderColor != null ? Border.all(color: borderColor!) : null,
              )
            : null,
        alignment: alignment,
        padding: padding,
        margin: margin,
        color: isTestMode
            ? WtColors.secondary.withOpacity(0.05)
            : borderRadius == null && borderColor == null
                ? backgroundColor
                : null,
        child: isTestMode
            ? Container(
                color: WtColors.secondary.withOpacity(0.1),
                child: child,
              )
            : child,
      );
}
