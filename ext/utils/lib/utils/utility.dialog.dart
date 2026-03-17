part of 'utility.dart';

/// 메시지 - 다이얼로그
///
///  * [title], 메시지 제목
///  * [content], 메시지 내용
///  * [actions], 버튼
///
Future defaultDialog({
  Widget? title,
  Widget? content,
  List<Widget>? actions,
  final bool barrierDismissible = true,
  final void Function(bool, dynamic)? onPopInvokedWithResult,
}) {
  return showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopScope(
          canPop: onPopInvokedWithResult == null,
          onPopInvokedWithResult: onPopInvokedWithResult,
          child: AlertDialog(
            elevation: 0.0,
            title: title != null ? Center(child: title) : null,
            content: SizedBox(
              width: maxWidth > 560 ? 560 : maxWidth,
              child: content,
            ),
            actions: actions == null ? null : [Row(children: actions)],
            titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
            contentPadding: const EdgeInsets.all(8.0),
            actionsPadding: const EdgeInsets.all(16.0),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            shape: brightness == Brightness.dark
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: colorScheme.onBackground, width: 1.5),
                  )
                : null,
          ),
        );
      });
}

/// 메시지 - 확장 다이얼로그
///
///  * [content], 메시지 내용
///  * [actions], 버튼
///
Future expandedDialog({
  Widget? title,
  required Widget content,
  List<Widget>? actions,
  double width = 900.0,
  double? height,
  EdgeInsets? insetPadding,
  final bool barrierDismissible = true,
  final void Function(bool, dynamic)? onPopInvokedWithResult,
}) {
  return showDialog(
      context: Get.overlayContext!,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopScope(
          onPopInvokedWithResult: onPopInvokedWithResult,
          child: AlertDialog(
            elevation: 0.0,
            title: title != null ? Center(child: title) : null,
            content: SizedBox(
              width: maxWidth - 32 > width ? width : maxWidth - 32,
              height: height,
              child: content,
            ),
            actions: actions == null ? null : [Row(mainAxisAlignment: MainAxisAlignment.center, children: actions)],
            titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
            contentPadding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
            actionsPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            insetPadding: insetPadding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 48.0),
            shape: brightness == Brightness.dark
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: colorScheme.onSurface, width: 1.5),
                  )
                : null,
          ),
        );
      });
}

/// 메시지 - 확장 다이얼로그
///
///  * [content], 메시지 내용
///  * [actions], 버튼
///
Future<bool?> fullscreenDialog({
  required Widget content,
  List<Widget>? actions,
  final bool barrierDismissible = true,
  final void Function(bool, dynamic)? onPopInvokedWithResult,
}) {
  return showDialog<bool>(
      context: Get.overlayContext!,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopScope(
          onPopInvokedWithResult: onPopInvokedWithResult,
          child: Dialog(
            elevation: 0.0,
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: content,
            ),
          ),
        );
      });
}

void closeDialog<T>({T? result}) {
  Get.searchDelegate(null).navigatorKey.currentState?.pop(result);
}

Future<void> closeDialogForAwaiting<T>({T? result}) async {
  showLoading(nothingIndicator: true);
  final completer = Completer();
  Get.searchDelegate(null).navigatorKey.currentState?.pop(result);
  WidgetsBinding.instance.addPostFrameCallback((_) => completer.complete());
  completer.future;
  hideLoading();
}

Future mediumDialog({
  Widget? title,
  Widget? content,
  BuildContext? context,
  List<Widget>? actions,
  final bool barrierDismissible = true,
  final void Function(bool, dynamic)? onPopInvokedWithResult,
}) {
  return showDialog(
      context: context ?? Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopScope(
          onPopInvokedWithResult: onPopInvokedWithResult,
          child: AlertDialog(
            elevation: 0.0,
            title: title,
            content: SizedBox(
              width: maxWidth < 592.0 ? maxWidth - 32.0 : 560.0,
              child: content,
            ),
            actions: [
              Row(
                  children: actions ??
                      [
                        const Spacer(),
                        Expanded(flex: 2, child: EasyOutlinedButton(onPressed: () => closeDialog(), child: '취소')),
                        const Spacer(),
                      ])
            ],
            titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            shape: brightness == Brightness.dark
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: colorScheme.onBackground, width: 1.5),
                  )
                : null,
          ),
        );
      });
}
