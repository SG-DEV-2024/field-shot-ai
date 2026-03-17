import 'package:utils/utils.dart';

const defaultValue = 56.0;

class Loader extends StatelessWidget {
  static final bytesTransferred = RxInt(0);
  static final percentTransferred = RxDouble(0.0);
  static final totalBytes = RxInt(0);

  static OverlayEntry? _currentLoader;
  static OverlayEntry? _currentIndicator;
  const Loader._(this._progressIndicator, this._themeData);
  final Widget? _progressIndicator;
  final ThemeData? _themeData;

  static OverlayState? _overlayState;

  static void show(
    BuildContext context, {
    /// Define your custom progress indicator if you want [optional]
    Widget? progressIndicator,

    /// Define Theme [optional]
    ThemeData? themeData,

    /// Define Overlay color [optional]
    Color? overlayColor,

    /// overlayTop mean overlay start from Top margin. If you have custom appbar then will be custom appbar height here.
    double? overlayFromTop,

    /// overlayFromBottom mean overlay end from Bottom margin.If you have custom BottomAppBar then will be custom BottomAppBar height here.
    double? overlayFromBottom,
  }) {
    _overlayState = context.findAncestorStateOfType<OverlayState>()!;
    if (_currentLoader == null) {
      ///Create current Loader Entry
      _currentLoader = OverlayEntry(builder: (context) {
        return Stack(
          children: <Widget>[
            Container(
              color: overlayColor ?? const Color(0x77ffffff),
            ),
            Center(
                child: Loader._(
              progressIndicator,
              themeData,
            )),
          ],
        );
      });
      try {
        _overlayState?.insertAll([_currentLoader!]);
        // WidgetsBinding.instance.addPostFrameCallback((_) => _overlayState?.insertAll([_currentLoader!]));
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  static Future<void> hide(int milliseconds) async {
    if (_currentLoader != null) {
      try {
        if (milliseconds > 0) await Future.delayed(Duration(milliseconds: milliseconds));
        _currentLoader?.remove();
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _currentLoader = null;
      }
    }
  }

  static void showIndicator(
    BuildContext context, {
    /// Define your custom progress indicator if you want [optional]
    Widget? progressIndicator,

    /// Define Theme [optional]
    ThemeData? themeData,

    /// Define Overlay color [optional]
    Color? overlayColor,

    /// overlayTop mean overlay start from Top margin. If you have custom appbar then will be custom appbar height here.
    double? overlayFromTop,

    /// overlayFromBottom mean overlay end from Bottom margin.If you have custom BottomAppBar then will be custom BottomAppBar height here.
    double? overlayFromBottom,
  }) {
    _overlayState = context.findAncestorStateOfType<OverlayState>()!;
    if (_currentIndicator == null) {
      /// Create current Loader Entry
      _currentIndicator = OverlayEntry(builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Loader._(
                progressIndicator,
                themeData,
              ),
            ],
          ),
        );
      });
      try {
        //WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          _overlayState?.insertAll([_currentIndicator!]);
        } catch (e) {
          log.warning('showIndicator: $e');
        }
        //});
      } catch (e) {
        log.warning('showIndicator: $e');
      }
    }
  }

  static void hideIndicator() {
    if (_currentIndicator != null) {
      try {
        _currentIndicator?.remove();
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _currentIndicator = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Theme(
            data: _themeData ??
                Theme.of(context)
                    .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: WtColors.secondary)),
            child: _progressIndicator ?? sizedBox0));
  }
}
