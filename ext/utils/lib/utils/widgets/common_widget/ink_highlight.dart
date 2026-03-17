import 'dart:async';
import 'package:flutter/material.dart';

class InkHighlightFactory extends InteractiveInkFeatureFactory {
  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) =>
      _InkHighlight(
        controller: controller,
        referenceBox: referenceBox,
        color: color,
        textDirection: textDirection,
        radius: radius,
        borderRadius: borderRadius,
        customBorder: customBorder,
        rectCallback: rectCallback,
        onRemoved: onRemoved,
      );
}

class _InkHighlight extends InkHighlight {
  _InkHighlight({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Color color,
    required TextDirection textDirection,
    required double? radius,
    required BorderRadius? borderRadius,
    required ShapeBorder? customBorder,
    required RectCallback? rectCallback,
    required VoidCallback? onRemoved,
  }) : super(
          controller: controller,
          referenceBox: referenceBox,
          color: color,
          textDirection: textDirection,
          radius: radius,
          borderRadius: borderRadius,
          customBorder: customBorder,
          rectCallback: rectCallback,
          onRemoved: onRemoved,
          fadeDuration: _duration,
        );

  static const _duration = Duration(milliseconds: 110);

  Timer? _timer;

  @override
  void confirm() {
    super.confirm();
    _timer?.cancel();
    _timer = Timer(_duration, cancel);
  }

  @override
  void cancel() {
    super.cancel();
    deactivate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
