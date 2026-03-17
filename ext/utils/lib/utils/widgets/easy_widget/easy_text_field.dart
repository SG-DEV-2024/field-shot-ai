import 'package:utils/utils.dart';

/// TextField의 스타일러스 필기 기능 설정
/// main app에서 초기화 시 설정하세요
class EasyTextFieldConfig {
  static bool stylusHandwritingEnabled = false;
}

class EasyTextField extends StatelessWidget {
  EasyTextField(
      {super.key,
      required this.controller,
      this.autofocus = false,
      this.readOnly = false,
      this.enabled,
      this.onEditingComplete,
      this.style,
      this.hintText,
      this.hintStyle,
      this.labelText,
      this.labelStyle,
      this.onChanged,
      this.validator,
      TextInputType? keyboardType,
      TextCapitalization? textCapitalization,
      TextInputAction? textInputAction,
      this.inputFormatters,
      this.minLines,
      this.maxLines = 1,
      this.expands,
      this.onTap,
      FocusNode? focusNode})
      : focusNode = focusNode ?? FocusNode(),
        keyboardType = keyboardType ?? TextInputType.text,
        textCapitalization = textCapitalization ?? TextCapitalization.none,
        textInputAction = textInputAction ?? (maxLines == 1 ? TextInputAction.done : TextInputAction.newline);

  final TextEditingController controller;
  final bool autofocus;
  final bool readOnly;
  final bool? enabled;
  final void Function()? onEditingComplete;
  final TextStyle? style;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final void Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final bool? expands;
  final GestureTapCallback? onTap; //! 추가
  late final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        if (!focusNode.hasFocus && onEditingComplete != null && textInputAction != TextInputAction.next) {
          onEditingComplete!();
        }
      },
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            readOnly: readOnly,
            enabled: enabled,
            style: style,
            decoration: InputDecoration(
              filled: true,
              fillColor: colorScheme.surfaceVariant.withAlpha(80),
              hintText: hintText,
              hintStyle: (hintStyle ?? const TextStyle()).gray2,
              labelText: labelText,
              labelStyle: (labelStyle ?? const TextStyle()).gray1,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: value.text.isEmpty || readOnly
                  ? sizedBox48
                  : ExcludeFocus(
                      child: IconButton(
                        onPressed: () => controller.clear(),
                        icon: Icon(MdiIcons.closeCircle, size: 24),
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          splashFactory: NoSplash.splashFactory,
                        ),
                      ),
                    ),
              contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
            ),
            onChanged: onChanged,
            onTapOutside: (_) => focusOut(),
            onFieldSubmitted: (_) {
              if (textInputAction == TextInputAction.next) {
                FocusManager.instance.primaryFocus?.nextFocus();
              }
            },
            validator: validator,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            textAlignVertical: const TextAlignVertical(y: 0.12),
            inputFormatters: inputFormatters,
            minLines: expands == true ? null : minLines,
            maxLines: expands == true ? null : maxLines,
            expands: expands ?? false,
            onTap: onTap,
            stylusHandwritingEnabled: EasyTextFieldConfig.stylusHandwritingEnabled,
          );
        },
      ),
    );
  }
}

class EasyTextFormField extends StatelessWidget {
  EasyTextFormField({
    super.key,
    required this.formKey,
    required this.controller,
    this.validator,
    this.onEditingComplete,
    this.hintText,
    this.inputFormatters,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final void Function()? onEditingComplete;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: colorScheme.surfaceVariant.withAlpha(80),
              hintText: hintText,
              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withAlpha(160)),
              suffixIcon: value.text.isEmpty
                  ? sizedBox48
                  : IconButton(
                      onPressed: () => controller.clear(),
                      icon: Icon(MdiIcons.closeCircle, size: 24),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        splashFactory: NoSplash.splashFactory,
                      ),
                    ),
              contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
            ),
            onTapOutside: (_) => focusOut(),
            onEditingComplete: onEditingComplete,
            validator: validator,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            textAlignVertical: const TextAlignVertical(y: 0.12),
            inputFormatters: inputFormatters,
            stylusHandwritingEnabled: EasyTextFieldConfig.stylusHandwritingEnabled,
          );
        },
      ),
    );
  }
}
