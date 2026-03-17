import 'package:utils/utils.dart';

part 'theme.color.dart';
part 'theme.colorv2.dart';

ThemeData mainTheme([Brightness? brightness, bool smallSegment = false]) {
  ColorScheme colorScheme = brightness == Brightness.light
      ? lightColorSchemeV2
      : brightness == Brightness.dark
          ? darkColorSchemeV2
          : lightColorSchemeV2;

  return ThemeData(
    useMaterial3: true,

    colorScheme: colorScheme,
    dialogBackgroundColor: colorScheme.background,

    // 앱바 테마
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.background,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      titleSpacing: -8.0,
      centerTitle: false,
    ),

    // 대화상자 테마
    dialogTheme: DialogThemeData(
      titleTextStyle: WtTextStyle.titleMedium.onBack.h1_5,
    ),

    // 텍스트 테마
    textTheme: TextTheme(
      displayLarge: WtTextStyle.displayLarge.copyWith(color: Colors.black),
      displayMedium: WtTextStyle.displayMedium.copyWith(color: Colors.black),
      // appBar
      displaySmall: WtTextStyle.displaySmall.copyWith(color: Colors.black),
      headlineLarge: WtTextStyle.headlineLarge.copyWith(color: Colors.black),
      headlineMedium: WtTextStyle.headlineMedium.copyWith(color: Colors.black),
      headlineSmall: WtTextStyle.headlineSmall.copyWith(color: Colors.black),
      titleLarge: WtTextStyle.titleLarge.copyWith(color: Colors.black),
      titleMedium: WtTextStyle.titleMedium.copyWith(color: Colors.black),
      titleSmall: WtTextStyle.titleSmall.copyWith(color: Colors.black),
      labelLarge: WtTextStyle.labelLarge.copyWith(color: Colors.black),
      labelMedium: WtTextStyle.labelMedium.copyWith(color: Colors.black),
      labelSmall: WtTextStyle.labelSmall.copyWith(color: Colors.black),
      // text field(style, label)
      bodyLarge: WtTextStyle.bodyLarge.copyWith(color: Colors.black),
      bodyMedium: WtTextStyle.bodyMedium.copyWith(color: Colors.black),
      // text field(helper, error, floating label)
      bodySmall: WtTextStyle.bodySmall.copyWith(color: Colors.black),
    ),

    //* text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: InkHighlightFactory(),
      ),
    ),

    //* filledButton theme
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: InkHighlightFactory(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),

    //* elevatedButton theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: InkHighlightFactory(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),

    //* outlinedButton theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: WtColors.primary), //xx 옥유아이
        backgroundColor: Colors.white, //!
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: InkHighlightFactory(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),

    //* segmentedButton theme
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashFactory: InkHighlightFactory(),
          iconSize: smallSegment ? materialAll<double>(16.0) : materialAll<double>(24.0),
          padding: materialAll<EdgeInsets>(EdgeInsets.symmetric(vertical: smallSegment ? 2.0 : 4.0)),
          textStyle: smallSegment ? materialAll(WtTextStyle.labelSmall) : null,
          // maximumSize: materialAll<Size>(const Size(40, 40)),
          // fixedSize: materialAll<Size>(const Size(40, 40)),
          foregroundColor: materialAll<Color>(Colors.black),
          backgroundColor:
              materialStateColor(WtColors.background, disabled: WtColors.gray3, selected: WtColors.secondaryContainer),
          shadowColor: materialAll<Color>(Colors.black),
          side: materialAll<BorderSide>(const BorderSide(color: Colors.black)),
          visualDensity: VisualDensity(horizontal: -4.0, vertical: smallSegment ? -2.0 : 0.0)),
      selectedIcon: sizedBox0,
    ),

    //* iconButton theme
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        splashFactory: InkHighlightFactory(),
      ),
    ),

    //* navigationBar theme
    navigationBarTheme: const NavigationBarThemeData(),

    //* tabBar theme
    tabBarTheme: TabBarThemeData(
      splashFactory: InkHighlightFactory(),
    ),

    //* bottomSheet theme
    bottomSheetTheme: const BottomSheetThemeData(modalBarrierColor: Colors.black26),

    //* divider theme
    dividerTheme: const DividerThemeData(space: 1.0),

    //* floatingActionButton theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      splashColor: Colors.transparent,
    ),

    //* 인풋 상자 꾸미기
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(borderSide: BorderSide(color: WtColors.osGrayBorder2)),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: WtColors.osGrayBorder2),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: WtColors.osGrayBorder2),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: WtColors.osGrayBorder2),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: WtColors.osError),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: WtColors.osError),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),

      hintStyle: WtTextStyle.osTextBig.osGrayBorder,
      errorStyle: WtTextStyle.osTextMedium.osErrorText,
    ),
  );
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

WidgetStateProperty<Color?>? materialStateColor(Color? normal, {Color? disabled, Color? pressed, Color? selected}) =>
    WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (disabled != null && states.contains(WidgetState.disabled)) {
          return disabled;
        }
        if (pressed != null && states.contains(WidgetState.pressed)) {
          return pressed;
        }
        if (selected != null && states.contains(WidgetState.selected)) {
          return selected;
        }
        return normal;
      },
    );

WidgetStateProperty<Color?>? materialSolidColor(Color? solid) => WidgetStatePropertyAll<Color?>(solid);

WidgetStateProperty<T> materialAll<T>(T all) => WidgetStatePropertyAll<T>(all);

WidgetStateProperty<BorderSide?>? materialStateBorder(Color normal, Color? disabled,
        {Color? pressed, Color? selected, double width = 1.0}) =>
    WidgetStateProperty.resolveWith<BorderSide?>(
      (Set<WidgetState> states) {
        final Color borderColor;
        if (disabled != null && states.contains(WidgetState.disabled)) {
          borderColor = disabled;
        } else if (pressed != null && states.contains(WidgetState.pressed)) {
          borderColor = pressed;
        } else if (selected != null && states.contains(WidgetState.selected)) {
          borderColor = selected;
        } else {
          borderColor = normal;
        }
        return BorderSide(color: borderColor, width: width);
      },
    );
