import 'package:utils/utils.dart';

enum WtInsideKind {
  prefixIcon,
  suffixIcon,
  suffixClear,
  prefixButton,
  suffixButton,
  prefixText,
  suffixText,
}

typedef BoolCallback = bool? Function();

class WtInsideButton extends StatefulWidget {
  //* 아이콘 버튼
  const WtInsideButton.prefixIcon({
    super.key,
    this.color,
    required this.icon,
    this.iconSize,
    required this.onPressed,
    this.focusNode,
  })  : label = null,
        text = null,
        onCleared = null,
        onTapDown = null,
        controller = null,
        kind = WtInsideKind.prefixIcon;

  const WtInsideButton.suffixIcon({
    super.key,
    this.color,
    required this.icon,
    this.iconSize,
    required this.onPressed,
    this.focusNode,
  })  : label = null,
        text = null,
        onCleared = null,
        onTapDown = null,
        controller = null,
        kind = WtInsideKind.suffixIcon;

  //* 텍스트 클리어 버튼
  // controller를 넣어주면 자동삭제, 아닐시 onCleared함수 구현
  const WtInsideButton.suffixClear({
    super.key,
    this.color,
    this.icon,
    this.iconSize,
    this.label,
    this.text,
    this.onCleared,
    this.onPressed,
    this.onTapDown,
    this.controller,
    this.focusNode,
  }) : kind = WtInsideKind.suffixClear;

  //* 아웃라인 버튼
  const WtInsideButton.prefixButton({
    super.key,
    this.color,
    this.label,
    this.onPressed,
    this.focusNode,
  })  : icon = null,
        iconSize = null,
        text = null,
        onCleared = null,
        onTapDown = null,
        controller = null,
        kind = WtInsideKind.prefixButton;

  const WtInsideButton.suffixButton({
    super.key,
    this.color,
    this.label,
    this.onPressed,
    this.focusNode,
  })  : icon = null,
        iconSize = null,
        text = null,
        onCleared = null,
        onTapDown = null,
        controller = null,
        kind = WtInsideKind.suffixButton;

  //* 텍스트
  WtInsideButton.prefixText({
    super.key,
    Color? color,
    this.text,
    this.onPressed,
    this.onTapDown,
    this.focusNode,
  })  : icon = null,
        iconSize = null,
        color = color ?? WtColors.gray1,
        label = null,
        onCleared = null,
        controller = null,
        kind = WtInsideKind.prefixText;

  WtInsideButton.suffixText({
    super.key,
    Color? color,
    this.text,
    this.onPressed,
    this.onTapDown,
    this.focusNode,
  })  : icon = null,
        iconSize = null,
        color = color ?? WtColors.gray1,
        label = null,
        onCleared = null,
        controller = null,
        kind = WtInsideKind.suffixText;

  final WtInsideKind kind;

  final Color? color;
  final dynamic icon;
  final double? iconSize;
  final dynamic label;
  final dynamic text;
  final BoolCallback? onCleared;
  final VoidCallback? onPressed;
  final void Function(TapDownDetails)? onTapDown;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<StatefulWidget> createState() => _WtInsideButtonState();
}

class _WtInsideButtonState extends State<WtInsideButton> {
  @override
  void initState() {
    super.initState();

    if (widget.kind == WtInsideKind.suffixClear && widget.focusNode != null) {
      widget.focusNode?.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.kind) {
      //* 아이콘 버튼
      case WtInsideKind.prefixIcon:
      case WtInsideKind.suffixIcon:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.kind == WtInsideKind.prefixIcon) sizedBox8,
            // 아이콘
            IconButton(
              onPressed: widget.onPressed == null
                  ? null
                  : () {
                      widget.focusNode?.requestFocus();
                      widget.onPressed!();
                    },
              icon: widget.icon is Widget
                  ? widget.icon
                  : Icon(widget.icon, color: WtColors.gray2, size: widget.iconSize ?? 24),
              style: _iconButtonStyle,
            ),
            sizedBox8,
          ],
        );

      //* 아웃라인 버튼
      case WtInsideKind.prefixButton:
      case WtInsideKind.suffixButton:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.kind == WtInsideKind.prefixButton) sizedBox8,
            // 버튼
            OutlinedButton(
              child: widget.label is Widget
                  ? widget.label
                  : Text(
                      widget.label as String,
                    ),
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(WtTextStyle.labelMedium),
                minimumSize: MaterialStateProperty.all(Size.zero),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                shape: MaterialStateProperty.all(const StadiumBorder()),
                foregroundColor: materialStateColor(WtColors.gray1, disabled: WtColors.gray3),
                side: materialStateBorder(WtColors.gray2, WtColors.gray4),
              ),
              onPressed: widget.onPressed == null
                  ? null
                  : () {
                      widget.focusNode?.requestFocus();
                      widget.onPressed!();
                    },
            ),
            sizedBox8,
          ],
        );

      //* 텍스트
      case WtInsideKind.prefixText:
      case WtInsideKind.suffixText:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: widget.kind == WtInsideKind.prefixText ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (widget.kind == WtInsideKind.prefixText) sizedBox8,
            // 텍스트
            GestureDetector(
              onTap: widget.onPressed == null
                  ? null
                  : () {
                      widget.focusNode?.requestFocus();
                      widget.onPressed!();
                    },
              onTapDown: widget.onTapDown,
              child: widget.text is Widget
                  ? widget.text
                  : Text(
                      widget.text as String,
                      style: WtTextStyle.bodyMedium.h1_5.copyWith(color: widget.color),
                    ),
            ),
            sizedBox8,
          ],
        );

      //* 텍스트 클리어 버튼
      case WtInsideKind.suffixClear:
        return widget.controller == null
            ? _clearWidget
            : ValueListenableBuilder(
                valueListenable: widget.controller!,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return _clearWidget;
                },
              );
    }
  }

  Widget get _clearWidget {
    if (_editableText == false && widget.icon == null && widget.label == null && widget.text == null) {
      return const SizedBox.shrink();
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.text != null) ...[
            // 텍스트
            GestureDetector(
              onTap: widget.onPressed == null
                  ? null
                  : () {
                      widget.focusNode?.requestFocus();
                      widget.onPressed!();
                    },
              onTapDown: widget.onTapDown,
              child: widget.text is Widget
                  ? widget.text
                  : Text(
                      widget.text as String,
                      style: WtTextStyle.bodyMedium.h1_5.copyWith(color: widget.color),
                    ),
            ),
            if (_editableText)
              SizedBox(
                height: 16,
                child: VerticalDivider(
                  width: 8,
                  thickness: 1,
                  color: WtColors.gray3,
                ),
              ),
          ],
          // 클리어 버튼
          if (_editableText)
            IconButton(
              onPressed: () {
                widget.focusNode?.requestFocus();
                //* onCleared에서 true를 리턴해야 텍스트를 지웁니다.
                if (widget.onCleared == null || widget.onCleared!() != false) {
                  widget.controller?.clear();
                }
              },
              icon: Icon(Icons.cancel_outlined, color: WtColors.gray2, size: widget.iconSize ?? 24),
              style: _iconButtonStyle,
            ),
          if (widget.icon != null) ...[
            if (_editableText)
              SizedBox(
                height: 16,
                child: VerticalDivider(
                  width: 4,
                  thickness: 1,
                  color: WtColors.gray3,
                ),
              ),
            IconButton(
              onPressed: widget.onPressed == null
                  ? null
                  : () {
                      widget.focusNode?.requestFocus();
                      widget.onPressed!();
                    },
              icon: widget.icon is Widget
                  ? widget.icon
                  : Icon(widget.icon, color: WtColors.gray2, size: widget.iconSize ?? 24),
              style: _iconButtonStyle,
            ),
          ],
          if (widget.label != null) ...[
            if (_editableText) ...[
              SizedBox(
                height: 16,
                child: VerticalDivider(
                  width: 8,
                  thickness: 1,
                  color: WtColors.gray3,
                ),
              ),
              const SizedBox(width: 2),
            ],
            // 버튼
            OutlinedButton(
              child: widget.label is Widget ? widget.label : Text(widget.label as String),
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(WtTextStyle.labelMedium),
                minimumSize: MaterialStateProperty.all(Size.zero),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
                shape: MaterialStateProperty.all(const StadiumBorder()),
                foregroundColor: materialStateColor(WtColors.gray1, disabled: WtColors.gray3),
                side: materialStateBorder(WtColors.gray2, WtColors.gray4),
              ),
              onPressed: widget.onPressed == null
                  ? null
                  : () {
                      widget.focusNode?.requestFocus();
                      widget.onPressed!();
                    },
            ),
          ],
          sizedBox8,
        ],
      );
    }
  }

  bool get _editableText => widget.controller?.text.isNotEmpty == true && widget.focusNode?.hasFocus == true;

  ButtonStyle get _iconButtonStyle => IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
        splashFactory: InkHighlightFactory(),
      );
}
