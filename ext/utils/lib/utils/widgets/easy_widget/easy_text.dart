import 'package:utils/utils.dart';

/// 기본 스타일은 WtTextStyle.size14
/// 기본 컬러값은 WtColors.grey0
class EasyText extends StatelessWidget {
  const EasyText(
    this.data, {
    super.key,
    this.color,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.style,
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.leading,
    this.alignment,
    this.textAlign,
    this.textScaler,
    this.fit,
    this.padding,
    this.margin,
    this.maxLines,
    this.overflow,
    //xx Device를 위한 잠시 사용되는 값들입니다.
    this.isBold,
    this.isMedium,
  });

  final String? data;
  final Color? color;
  final double? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final TextStyle? style;
  final double? width;
  final double? height;
  final double? maxWidth;
  final double? maxHeight;
  final double? leading;
  final AlignmentGeometry? alignment;
  final TextAlign? textAlign;
  final TextScaler? textScaler;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final int? maxLines;
  final TextOverflow? overflow;
  //xx Device를 위한 잠시 사용되는 값들입니다.
  final bool? isBold;
  final bool? isMedium;

  @override
  Widget build(BuildContext context) {
    if (fit != null) {
      return FittedBox(
          fit: fit!,
          alignment: alignment ?? Alignment.center,
          child: _constraints(context, alignment ?? Alignment.center));
    } else {
      return _constraints(context, alignment);
    }
  }

  Widget _constraints(BuildContext context, AlignmentGeometry? alignment) {
    if (width != null ||
        height != null ||
        maxWidth != null ||
        maxHeight != null ||
        alignment != null ||
        padding != null ||
        margin != null) {
      return EasyConstraints(
        width: width,
        height: height,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        alignment: alignment,
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        child: _text(context, alignment),
      );
    } else {
      return _text(context, alignment);
    }
  }

  Widget _text(BuildContext context, AlignmentGeometry? alignmentGeometry) {
    Alignment? alignment = alignmentGeometry is Alignment ? alignmentGeometry : null;
    TextAlign? textAlign = this.textAlign ??
        (alignment != null
            ? (alignment.x == 0
                ? TextAlign.center
                : alignment.x > 0
                    ? TextAlign.right
                    : TextAlign.left)
            : null);
    //xx Device를 위한 잠시 사용되는 값들입니다. isBold와 isMedium
    TextStyle style = (this.style ?? DefaultTextStyle.of(context).style).copyWith(
        color: color, fontWeight: isBold == true ? FontWeight.w600 : (isMedium == true ? FontWeight.w500 : null));
    double defaultLeading = style.fontVariations?.last.axis == 'lead' ? style.fontVariations!.last.value : 0.41667;

    return Text(
      data ?? '',
      style: color != null ? style : style,
      maxLines: maxLines,
      overflow: maxLines != null && overflow == null
          ? TextOverflow.ellipsis
          : overflow, // TextOverflow.ellipsis은 web에서 버그 발생!
      textAlign: textAlign,
      strutStyle: StrutStyle(fontSize: style.fontSize, leading: leading ?? defaultLeading, height: 1.0),
      textScaler: textScaler,
    );
  }
}
