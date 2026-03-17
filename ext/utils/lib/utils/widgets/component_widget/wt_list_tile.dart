import 'package:utils/utils.dart';

class WtListTile extends StatelessWidget {
  /// 통합형 리스트타일
  ///
  /// 내부에 터치이벤트 위젯이 있는경우 전체 위젯으로 이벤트 바인딩함.
  ///
  /// 바인딩 순서
  ///
  /// 1.onPressed 옵션 사용
  ///
  /// 2.leading Widget
  ///
  /// 3.title Widget
  ///
  /// 4.trailing Widget
  ///
  /// 바인딩 기능을 사용하지 않으려면 useEventLink = false로 설정
  ///
  const WtListTile({
    Key? key,
    this.leading,
    this.leadingAlign = Alignment.centerLeft,
    this.leadingScaleFactor,
    this.leadingTitleGap = 8,
    this.title,
    this.titleAlign = Alignment.centerLeft,
    this.titleTrailingGap = 8,
    this.trailing,
    this.trailingAlign = Alignment.centerRight,
    this.trailingScaleFactor,
    this.padding,
    this.defaultPadding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.width = double.infinity,
    this.height = 48,
    this.decoration,
    this.useEventLink = true,
    this.showTapEffect = false,
    this.onPressed,
  }) : super(key: key);

  /// 전열에 배치될 위젯
  final Widget? leading;

  /// 전열 정렬
  final Alignment leadingAlign;

  /// 전열 고정 사이즈 비율(0.1 = 10%)
  final double? leadingScaleFactor;

  /// 전열-중열 사이 간격
  final double? leadingTitleGap;

  /// 중열에 배치될 위젯
  final Widget? title;

  /// 중열 정렬
  final Alignment titleAlign;

  /// 전열-중열 사이 간격
  final double? titleTrailingGap;

  /// 후열 위젯
  final Widget? trailing;

  /// 후열 정렬
  final Alignment trailingAlign;

  /// 후열 고정 사이즈 비율(0.1 = 10%)
  final double? trailingScaleFactor;

  /// 추가 패딩
  final EdgeInsetsGeometry? padding;

  /// 기본 패딩
  final EdgeInsetsGeometry? defaultPadding;

  /// 행 정렬 기준
  final MainAxisAlignment mainAxisAlignment;

  /// 열 정렬 기준
  final CrossAxisAlignment crossAxisAlignment;

  /// 행 사이즈
  final MainAxisSize mainAxisSize;

  /// 기본 가로 사이즈
  final double width;

  /// 기본 세로 사이즈
  final double height;

  /// 데코레이션
  final Decoration? decoration;

  /// 클릭 이펙트 표시 여부
  final bool showTapEffect;

  /// 이벤트 바인딩 사용 여부
  final bool useEventLink;

  /// 클릭 이벤트
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: showTapEffect ? null : Colors.transparent,
      hoverColor: showTapEffect ? null : Colors.transparent,
      splashColor: showTapEffect ? null : Colors.transparent,
      onTap: eventConnection(),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Container(
          padding: defaultPadding ?? const EdgeInsets.symmetric(vertical: 8),
          decoration: decoration,
          constraints: BoxConstraints(
            maxWidth: width,
            minHeight: height,
          ),
          child: LayoutBuilder(builder: (context, boxConstraints) {
            double maxWidth = boxConstraints.maxWidth;
            return Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: mainAxisSize,
              children: [
                SizedBox(
                  width: leadingScaleFactor != null ? maxWidth * leadingScaleFactor! : null,
                  child: Align(
                    alignment: leadingAlign,
                    child: IgnorePointer(
                      ignoring: useEventLink,
                      child: getLeadingWidget(),
                    ),
                  ),
                ),
                if (leadingTitleGap != null && leadingScaleFactor == null) ...[
                  SizedBox(
                    width: leadingTitleGap,
                  ),
                ],
                if (title != null) ...[
                  mainAxisSize == MainAxisSize.max
                      ? Expanded(
                          child: Align(
                            alignment: titleAlign,
                            child: IgnorePointer(
                              ignoring: useEventLink,
                              child: getTitleWidget(),
                            ),
                          ),
                        )
                      : Align(
                          alignment: titleAlign,
                          child: IgnorePointer(
                            ignoring: useEventLink,
                            child: getTitleWidget(),
                          ),
                        ),
                ] else ...[
                  const Spacer()
                ],
                if (titleTrailingGap != null && trailingScaleFactor == null && trailing != null) ...[
                  SizedBox(
                    width: titleTrailingGap,
                  ),
                ],
                SizedBox(
                  width: trailingScaleFactor != null ? maxWidth * trailingScaleFactor! : null,
                  child: Align(
                    alignment: trailingAlign,
                    child: IgnorePointer(
                      ignoring: useEventLink,
                      child: getTrailingWidget(),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget getLeadingWidget() {
    return leading ?? const SizedBox.shrink();
  }

  Widget getTitleWidget() {
    return title ?? const SizedBox.shrink();
  }

  Widget getTrailingWidget() {
    return trailing ?? const SizedBox.shrink();
  }

  Function()? eventConnection() {
    if (onPressed != null) return onPressed;
    if (leading == null && trailing == null) return null;
    if (useEventLink == false) return null;

    Widget leadingTemp = leading ?? const SizedBox.shrink();
    Widget titleTemp = title ?? const SizedBox.shrink();
    Widget trailingTemp = trailing ?? const SizedBox.shrink();

    if (leadingTemp is GestureDetector) {
      return leadingTemp.onTap;
    } else if (titleTemp is GestureDetector) {
      return titleTemp.onTap;
    } else if (trailingTemp is GestureDetector) {
      return trailingTemp.onTap;
    } else if (leadingTemp is InkWell) {
      return leadingTemp.onTap;
    } else if (titleTemp is InkWell) {
      return titleTemp.onTap;
    } else if (trailingTemp is InkWell) {
      return trailingTemp.onTap;
    } else if (leadingTemp is ButtonStyleButton) {
      return leadingTemp.onPressed;
    } else if (titleTemp is ButtonStyleButton) {
      return titleTemp.onPressed;
    } else if (trailingTemp is ButtonStyleButton) {
      return trailingTemp.onPressed;
    } else if (leadingTemp is IconButton) {
      return leadingTemp.onPressed;
    } else if (titleTemp is IconButton) {
      return titleTemp.onPressed;
    } else if (trailingTemp is IconButton) {
      return trailingTemp.onPressed;
    } else if (leadingTemp is WtIconButton) {
      return leadingTemp.onPressed;
    } else if (titleTemp is WtIconButton) {
      return titleTemp.onPressed;
    } else if (trailingTemp is WtIconButton) {
      return trailingTemp.onPressed;
    } else if (leadingTemp is EasyRadioButton) {
      return () {
        if (leadingTemp.key is GlobalKey<EasyRadioButtonState>) {
          GlobalKey<EasyRadioButtonState> globalKey = leadingTemp.key as GlobalKey<EasyRadioButtonState>;
          globalKey.currentState!.onChanged();
        }
      };
    } else if (titleTemp is EasyRadioButton) {
      return () {
        if (titleTemp.key is GlobalKey<EasyRadioButtonState>) {
          GlobalKey<EasyRadioButtonState> globalKey = titleTemp.key as GlobalKey<EasyRadioButtonState>;
          globalKey.currentState!.onChanged();
        }
      };
    } else if (trailingTemp is EasyRadioButton) {
      return () {
        if (trailingTemp.key is GlobalKey<EasyRadioButtonState>) {
          GlobalKey<EasyRadioButtonState> globalKey = trailingTemp.key as GlobalKey<EasyRadioButtonState>;
          globalKey.currentState!.onChanged();
        }
      };
    } else if (leadingTemp is EasyCheckButton) {
      return () {
        if (leadingTemp.key is GlobalKey<EasyCheckButtonState>) {
          GlobalKey<EasyCheckButtonState> globalKey = leadingTemp.key as GlobalKey<EasyCheckButtonState>;
          globalKey.currentState!.onChanged();
        }
      };
    } else if (titleTemp is EasyCheckButton) {
      return () {
        if (titleTemp.key is GlobalKey<EasyCheckButtonState>) {
          GlobalKey<EasyCheckButtonState> globalKey = titleTemp.key as GlobalKey<EasyCheckButtonState>;
          globalKey.currentState!.onChanged();
        }
      };
    } else if (trailingTemp is EasyCheckButton) {
      return () {
        if (trailingTemp.key is GlobalKey<EasyCheckButtonState>) {
          GlobalKey<EasyCheckButtonState> globalKey = trailingTemp.key as GlobalKey<EasyCheckButtonState>;
          globalKey.currentState!.onChanged();
        }
      };
    } else {
      return null;
    }
  }
}
