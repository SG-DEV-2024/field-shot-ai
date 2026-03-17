import 'package:utils/utils.dart';

class WtTextFormField extends StatefulWidget {
  const WtTextFormField({
    Key? key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.toolbarOptions,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.onFocusChange,
    this.isClearButton = true,
    this.onCleared,
    this.showErrorOrHintText = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets? scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final ValueChanged<bool>? onFocusChange;
  final bool isClearButton;
  final BoolCallback? onCleared; //* onCleared에서 true를 리턴해야 텍스트를 지웁니다.
  final bool showErrorOrHintText;

  @override
  State<StatefulWidget> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends State<WtTextFormField> {
  late final TextEditingController textCtrl;
  late final FocusNode focusNode;

  /* 
  keyboardType: TextInputType.phone or TextInputType.number를 사용할 경우 
  TextEditingController에서 문제가 발생되 정상적으로 입력이 안되는 버그로 
  StatefulWidget으로 변경하여 initState에서 TextEditingController를 초기화하여 문제를 해결함
  */

  @override
  void initState() {
    super.initState();
    textCtrl = widget.controller ?? TextEditingController(text: widget.initialValue);
    focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.controller == null) textCtrl.dispose();
    if (widget.focusNode == null) focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: widget.onFocusChange,
      child: TextFormField(
        controller: textCtrl,
        initialValue: null,
        focusNode: focusNode,
        decoration: getDecoration(),
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        style: widget.style ?? WtTextStyle.bodyLarge.gray1.copyWith(letterSpacing: 0.4),
        strutStyle:
            widget.strutStyle ?? StrutStyle(fontSize: widget.style?.fontSize ?? 16, leading: 0.41667, height: 1.0),
        textDirection: widget.textDirection,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        toolbarOptions: widget.toolbarOptions,
        showCursor: widget.showCursor,
        obscuringCharacter: widget.obscuringCharacter,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        enableSuggestions: widget.enableSuggestions,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        onSaved: widget.onSaved,
        validator: widget.validator,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        cursorWidth: widget.cursorWidth ?? 2.0,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        keyboardAppearance: widget.keyboardAppearance,
        scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
        enableInteractiveSelection: widget.enableInteractiveSelection,
        selectionControls: widget.selectionControls,
        buildCounter: widget.buildCounter,
        scrollPhysics: widget.scrollPhysics,
        autofillHints: widget.autofillHints,
        autovalidateMode: widget.autovalidateMode,
        scrollController: widget.scrollController,
        restorationId: widget.restorationId,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
        stylusHandwritingEnabled: EasyTextFieldConfig.stylusHandwritingEnabled,
      ),
    );
  }

  InputDecoration getDecoration() {
    InputDecoration decoration;

    decoration = widget.isClearButton
        ? (widget.decoration.suffixIcon == null
            ? widget.decoration.copyWith(
                //xx filled: widget.showErrorOrHintText ? true : false,
                suffixIcon:
                    WtInsideButton.suffixClear(controller: textCtrl, focusNode: focusNode, onCleared: widget.onCleared),
                suffixIconConstraints: const BoxConstraints(),
              )
            : (widget.decoration.suffixIcon is WtInsideButton
                ? widget.decoration.copyWith(
                    //xx filled: widget.showErrorOrHintText ? true : false,
                    suffixIcon: WtInsideButton.suffixClear(
                      controller: textCtrl,
                      focusNode: focusNode,
                      onCleared: widget.onCleared ?? (widget.decoration.suffixIcon as WtInsideButton).onCleared,
                      color: (widget.decoration.suffixIcon as WtInsideButton).color,
                      icon: (widget.decoration.suffixIcon as WtInsideButton).icon,
                      iconSize: (widget.decoration.suffixIcon as WtInsideButton).iconSize,
                      label: (widget.decoration.suffixIcon as WtInsideButton).label,
                      text: (widget.decoration.suffixIcon as WtInsideButton).text,
                      onPressed: (widget.decoration.suffixIcon as WtInsideButton).onPressed,
                      onTapDown: (widget.decoration.suffixIcon as WtInsideButton).onTapDown,
                    ),
                    suffixIconConstraints: const BoxConstraints(),
                  )
                : widget.decoration.copyWith(/* filled: widget.showErrorOrHintText ? true : false */)))
        : widget.decoration.copyWith(/* filled: widget.showErrorOrHintText ? true : false */);

    if (widget.maxLines?.toInt() == 1) {
      decoration.copyWith(contentPadding: const EdgeInsets.symmetric(vertical: 16.5, horizontal: 8));
    }

    return decoration;
  }
}
