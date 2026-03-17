import 'dart:developer' as dev;

import 'package:intl/intl.dart';
import 'package:logging/logging.dart' as logging;
import 'package:utils/utils.dart';

part 'utility.brightness.dart';
part 'utility.dialog.dart';
part 'utility.global.dart';
part 'utility.log.dart';
part 'utility.typecast.dart';

// 파일이 없어서 오류가 나는경우 콘솔 -> ./script -> 2 -> 파일생성(post_config.dart)
//xx import 'package:utils/config.dart' as config;

/// 디바이스 최대 가로길이
double get maxWidth => Get.width;

/// 디바이스 최대 세로길이
double get maxHeight => Get.height;

/// 컨텐츠 최대 세로길이
double get bodyHeight => maxHeight - kToolbarHeight - safeAreaTop; // - kBottomNavigationBarHeight - safeAreaBottom;

/// 디바이스 세이프 탑영역 사이즈
double get safeAreaTop => Get.context!.mediaQueryPadding.top;

/// 디바이스 세이프 바텀영역 사이즈
double get safeAreaBottom => Get.context!.mediaQueryPadding.bottom;

/// 디바이스 세이프 죄측 영역 사이즈
//xx double get safeAreaLeft => Get.context!.mediaQueryPadding.left;

/// 디바이스 세이프 우측 영역 사이즈
//xx double get safeAreaRight => Get.context!.mediaQueryPadding.right;

/// 디버그모드 확인
bool get isDebugMode => kDebugMode;

/// 테스트모드 확인
bool get isTestMode => kDebugMode && false; // 켜줄 때는 true, 꺼줄 때는 false

/// Android 운영체제 확인
bool get isAndroid => kIsWeb ? false : Platform.isAndroid;

/// IOS 운영체제 확인
bool get isIOS => kIsWeb ? false : Platform.isIOS;

/// Phone 확인
bool get isPhone => !kIsWeb && (Get.context?.mediaQueryShortestSide ?? 600) < 600.0;

/// Base64문자 -> utf8 문자로 디코딩
String base64ToString(String data) {
  return utf8.fuse(base64).decode(data);
}

//xx final GlobalKey<FrameUserState> frameUserKey = GlobalKey<FrameUserState>();
//xx final GlobalKey<RecordScreenState> recordScreenKey = GlobalKey<RecordScreenState>();

/// 바텀 화면 변경 및 상세페이지 진입 시 사용
///
/// ```dart
///
/// changePage(1);
/// changePage(2);
/// changePage(4, pages: [const SamplePage(),const SamplePage(),const SamplePage()]);
///
///
/// ```
//xx Function(int index, {List<Widget> pages}) get bottomChangePage => frameUserKey.currentState!.bottomChangePage;

/// 퍼미션 체크
//xx Future<bool> get checkPhotosPermission async =>
//     (isIOS && (await Permission.photos.request().isGranted || await Permission.photos.request().isLimited)) ||
//     (isAndroid &&
//         ((androidInfo.version.sdkInt >= 33 && await Permission.photos.request().isGranted) ||
//             (androidInfo.version.sdkInt < 33 && await Permission.storage.request().isGranted)));
//xx Future<bool> get checkCameraPermission async => (await Permission.camera.request().isGranted);

/// URL연결(인터넷,전화,문자,이메일)
///
/// ```dart
/// url:'www.naver.com', urlType:UrlType.INTERNET -> 'https://www.naver.com'
/// url:'01012345678', urlType:UrlType.TEL -> 'tel:01012345678'
/// 전역에서 사용가능
///
/// 로딩 표시
void onlyLoading({Color? progressIndicatorColor}) => showLoading(
    progressIndicatorColor: progressIndicatorColor ?? colorScheme.primary, overlayColor: Colors.transparent);

/// 전역에서 사용가능
///
/// 로딩 표시
void showLoading({Color? progressIndicatorColor, Color? overlayColor, bool? nothingIndicator}) => Loader.show(
      Get.overlayContext!,
      progressIndicator: nothingIndicator == true
          ? null
          : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColor ?? colorScheme.primary),
            ),
      overlayColor: nothingIndicator == true ? Colors.transparent : overlayColor,
    );

/// 전역에서 사용가능
///
/// 로딩 숨기기
Future<void> hideLoading([int milliseconds = 110]) async {
  await Loader.hide(milliseconds);
}

void showIndicator({int total = 0, Color? progressIndicatorColor, Color? overlayColor, bool? nothingIndicator}) {
  Loader.bytesTransferred.call(0);
  Loader.percentTransferred.call(0.0);
  Loader.totalBytes(total);

  Loader.showIndicator(
    Get.overlayContext!,
    themeData: Theme.of(Get.overlayContext!),
    progressIndicator: nothingIndicator == true
        ? null
        : Obx(
            () => Stack(
              children: [
                LinearProgressIndicator(
                  minHeight: 16.0,
                  value: (Loader.bytesTransferred.value /*  + Loader.percentTransferred.value */) /
                      (Loader.totalBytes.value <= 0 ? 1 : Loader.totalBytes.value),
                  valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColor ?? colorScheme.primary),
                ),
                if (Loader.totalBytes.value > 10000)
                  DefaultTextStyle(
                    style: WtTextStyle.osTextSmallBold.osStrokeButton,
                    child: EasyText(
                      '${Loader.bytesTransferred.value.toFileSize()} / ${Loader.totalBytes.value.toFileSize()}',
                      alignment: Alignment.center,
                    ),
                  )
                else if (Loader.percentTransferred.value > 0)
                  DefaultTextStyle(
                    style: WtTextStyle.osTextSmallBold.osStrokeButton,
                    child: EasyText(
                      '${Loader.percentTransferred.value.toInt()}%',
                      alignment: Alignment.center,
                    ),
                  ),
              ],
            ),
          ),
    overlayColor: nothingIndicator == true ? Colors.transparent : overlayColor,
  );
}

void totalIndicator([int total = 1, int increase = 0]) {
  Loader.bytesTransferred.call(increase);
  Loader.percentTransferred.call(0.0);
  Loader.totalBytes(total);
}

void increaseIndicator([int increase = 1]) {
  Loader.percentTransferred.call(0.0);
  Loader.bytesTransferred(Loader.bytesTransferred.value + increase);
}

void percentIndicator(double percent) {
  Loader.percentTransferred.call(percent);
}

/// 전역에서 사용가능
///
/// 로딩 숨기기
Future<void> hideIndicator() async {
  await Future.delayed(const Duration(milliseconds: 220));
  Loader.hideIndicator();
  Loader.totalBytes(null);
}

/// 팝업
///
/// ‼️ 포지션이 안맞는 경우 동작하는 위젯을 Builder로 감싸줘야함.
Future<T?> defaultMenu<T>({
  BuildContext? context,
  required List<PopupMenuEntry<T>> items,
  RelativeRect? initPosition,
  double elevation = 8.0,
  Color? color,
  T? initialValue,
  String? semanticLabel,
  ShapeBorder? shape,
  bool useRootNavigator = false,
}) {
  RenderBox box = (context ?? Get.context!).findRenderObject() as RenderBox;
  Offset position = box.localToGlobal(Offset.zero);

  return showMenu<T>(
    context: context ?? Get.context!,
    position: initPosition ??
        RelativeRect.fromLTRB(
            position.dx, position.dy + 50, 0.0, 0.0), //position where you want to show the menu on screen
    items: items,
    elevation: elevation,
    color: color,
    initialValue: initialValue,
    semanticLabel: semanticLabel,
    shape: shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
    useRootNavigator: useRootNavigator,
  );
}

/// 메시지 - Show Modal Bottom Sheet
Future<T?> defaultModalBottomSheet<T>({
  BuildContext? context,
  required Widget widget,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  double? heightFactor,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
}) {
  return showModalBottomSheet(
    context: context ?? Get.context!,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: heightFactor,
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: true,
          child: widget,
        ),
      );
    },
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape ??
        const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        )),
    clipBehavior: clipBehavior,
    constraints: constraints,
    barrierColor: barrierColor,
    isScrollControlled: heightFactor != null ? true : isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    routeSettings: routeSettings,
    transitionAnimationController: transitionAnimationController,
  );
}

/// 스낵바
defaultSnackbar(
  dynamic message, {
  dynamic title,
  bool? long,
  bool center = false,
  bool warning = false,
  SnackBarAction? mainAction,
}) async {
  Widget? titleText, messageText;
  if (title is Widget) {
    titleText = title;
  } else if (title is String) {
    titleText = Text(title, style: WtTextStyle.titleMedium.copyWith(color: colorScheme.onInverseSurface));
  }

  if (message is Widget) {
    messageText = message;
  } else if (message is String) {
    messageText = Text(message, style: TextStyle(color: colorScheme.onInverseSurface));
  }

  ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    //! _snackBarTransitionDuration를 550으로
    SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titleText != null) ...[
            titleText,
            sizedBox8,
          ],
          if (messageText != null) messageText,
        ],
      ),
      backgroundColor: warning ? WtColors.error : null,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: (long == true ? 4 : (long == false ? 1 : 2))),
      action: mainAction,
      width: center
          ? null
          : maxWidth > 480.0
              ? 480.0 - 32.0
              : maxWidth - 32.0,
      margin: center //! 키보드가 보이는 상황이면 에러!
          ? EdgeInsets.only(
              left: (maxWidth - 480.0) * 0.5,
              right: (maxWidth - 480.0) * 0.5,
              bottom: maxHeight * 0.5,
            )
          : null,
    ),
  );
}

/// 토스트
enum ToastPosition {
  top,
  bottom,
  center,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  centerLeft,
  centerRight,
  snackbar,
  none,
}

defaultToast(
  String message, {
  bool? long,
  bool warning = false,
  ToastPosition position = ToastPosition.center,
}) async {
  if (Get.key.currentContext != null) {
    fToast.init(Get.key.currentContext!);
    return fToast.showToast(
      child: Container(
        //width: maxWidth > 480.0 ? 480.0 - 32.0 : maxWidth - 32.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
            color: warning ? WtColors.error : (Get.theme.snackBarTheme.backgroundColor ?? WtColors.inverseSurface),
            borderRadius: BorderRadius.circular(4.0)),
        child: EasyText(message,
            style: WtTextStyle.titleLarge.copyWith(
                // WtTextStyle.titleMedium
                color: warning
                    ? WtColors.onError
                    : (Get.theme.snackBarTheme.contentTextStyle?.color ?? WtColors.onInverseSurface)),
            maxLines: long == true ? 7 : 2),
      ),
      gravity: ToastGravity.values[position.index],
      toastDuration: Duration(seconds: long == true ? 4 : (long == false ? 1 : 2)),
    );
  }
}

/// 현재 스낵바 닫기
closeSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

void focusOut() => FocusManager.instance.primaryFocus!.unfocus();
