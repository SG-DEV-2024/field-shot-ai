import 'package:utils/utils.dart';

extension WtWidgetExtension on Widget {
  ///불러오는 화면으로 부터 데이터를 받는 경우 사용
  //xx Future<dynamic> getData<T>() {
  //   return WtNavigator.push(
  //     child: this,
  //   );
  // }

  Widget background(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
      ),
      child: this,
    );
  }

  Widget cornerRadius(BorderRadius? radius) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.zero,
      child: this,
    );
  }

  Widget align([AlignmentGeometry alignment = Alignment.center]) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  Widget padding([EdgeInsetsGeometry? value]) {
    value ??= const EdgeInsets.all(16);
    return Padding(
      padding: value,
      child: this,
    );
  }

  Widget wrapBuilder() {
    return Builder(builder: (context) {
      return this;
    });
  }
}

extension InkWellExtension on InkWell {
  InkWell isEffectOff() {
    return InkWell(
      autofocus: autofocus,
      borderRadius: borderRadius,
      canRequestFocus: canRequestFocus,
      customBorder: customBorder,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusColor: focusColor,
      focusNode: focusNode,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      key: key,
      mouseCursor: mouseCursor,
      onDoubleTap: onDoubleTap,
      onFocusChange: onFocusChange,
      onHighlightChanged: onHighlightChanged,
      onHover: onHover,
      onLongPress: onLongPress,
      onTap: onTap,
      onTapCancel: onTapCancel,
      onTapDown: onTapDown,
      overlayColor: overlayColor,
      radius: radius,
      splashColor: Colors.transparent,
      splashFactory: splashFactory,
      child: child,
    );
  }
}

extension ScrollEffect on SingleChildScrollView {
  Widget scrollEffectOff() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: this,
    );
  }
}

extension ScrollEffect2 on WtSingleChildScrollView {
  Widget scrollEffectOff() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: this,
    );
  }
}

extension ScrollEffect3 on ListView {
  Widget scrollEffectOff() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: this,
    );
  }
}

extension ScrollEffect4 on TabBarView {
  Widget scrollEffectOff() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: this,
    );
  }
}

extension ScrollEffect5 on GridView {
  Widget scrollEffectOff() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: this,
    );
  }
}

extension ScrollEffect6 on NestedScrollView {
  Widget scrollEffectOff() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: this,
    );
  }
}
