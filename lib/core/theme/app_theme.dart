import 'package:blackbook/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  const AppTheme._();

  static final appFontFamily = 'Poppins';

  static OutlineInputBorder _inputBorder(
          [Color color = AppPallete.borderLightColor]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(width: 1.5, color: color),
      );

  static const lightStatusBarTheme = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: AppPallete.backgroundColor,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppPallete.backgroundColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    fontFamily: appFontFamily,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppPallete.primaryColor,
      onPrimary: AppPallete.whiteColor,
      secondary: AppPallete.primaryColor,
      onSecondary: AppPallete.whiteColor,
      error: AppPallete.errorColor,
      onError: AppPallete.whiteColor,
      surface: AppPallete.surfaceColor,
      onSurface: AppPallete.darkTextColor,
    ),
    useMaterial3: true,
    hoverColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      surfaceTintColor: AppPallete.backgroundColor,
      foregroundColor: AppPallete.darkTextColor,
      toolbarHeight: 80,
      systemOverlayStyle: lightStatusBarTheme,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(
          top: Radius.circular(15),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppPallete.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: AppPallete.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.hardEdge,
      shadowColor: Colors.transparent,
      color: AppPallete.surfaceColor,
      surfaceTintColor: AppPallete.surfaceColor,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    dividerTheme: const DividerThemeData(
      thickness: 0.5,
      color: Color(0xFFBBBBBB),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(AppPallete.borderDarkColor),
      contentPadding: EdgeInsets.all(16),
      hintStyle: TextStyle(fontSize: 14),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    tabBarTheme: TabBarThemeData(
      dividerHeight: 0.5,
      overlayColor: WidgetStatePropertyAll(
        AppPallete.lightTextColor.withAlpha(30),
      ),
      labelColor: AppPallete.darkTextColor,
      dividerColor: AppPallete.borderLightColor,
      indicatorColor: AppPallete.borderDarkColor,
      unselectedLabelColor: AppPallete.normalTextColor.withAlpha(120),
    ),
    extensions: [
      AppColors(
        borderLightColor: AppPallete.borderLightColor,
        borderNormalColor: AppPallete.borderNormalColor,
        borderDarkColor: AppPallete.borderDarkColor,
        deepTextColor: AppPallete.deepTextColor,
        darkTextColor: AppPallete.darkTextColor,
        normalTextColor: AppPallete.normalTextColor,
        lightTextColor: AppPallete.lightTextColor,
      ),
    ],
  );

  static const darkStatusBarTheme = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: AppPallete.backgroundColorDark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppPallete.backgroundColorDark,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: AppPallete.backgroundColorDark,
      fontFamily: appFontFamily,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppPallete.primaryColor,
        onPrimary: AppPallete.whiteColor,
        secondary: AppPallete.primaryColor,
        onSecondary: AppPallete.whiteColor,
        error: AppPallete.errorColorDark,
        onError: AppPallete.whiteColor,
        surface: AppPallete.surfaceColorDark,
        onSurface: AppPallete.darkTextColorDark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPallete.backgroundColorDark,
        surfaceTintColor: AppPallete.backgroundColorDark,
        foregroundColor: AppPallete.darkTextColorDark,
        toolbarHeight: 80,
        systemOverlayStyle: darkStatusBarTheme,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.vertical(
            top: Radius.circular(15),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppPallete.backgroundColorDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: AppPallete.surfaceColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      cardTheme: CardThemeData(
        clipBehavior: Clip.hardEdge,
        shadowColor: Colors.transparent,
        color: AppPallete.surfaceColorDark,
        surfaceTintColor: AppPallete.surfaceColorDark,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 0.5,
        color: AppPallete.borderLightColorDark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: _inputBorder(AppPallete.borderLightColorDark),
        enabledBorder: _inputBorder(AppPallete.borderLightColorDark),
        focusedBorder: _inputBorder(AppPallete.borderDarkColorDark),
        contentPadding: EdgeInsets.all(16),
        hintStyle: TextStyle(fontSize: 14),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        dividerHeight: 0.5,
        overlayColor: WidgetStatePropertyAll(
          AppPallete.lightTextColorDark.withAlpha(30),
        ),
        labelColor: AppPallete.darkTextColorDark,
        dividerColor: AppPallete.borderLightColorDark,
        indicatorColor: AppPallete.borderDarkColorDark,
        unselectedLabelColor: AppPallete.normalTextColorDark.withAlpha(120),
      ),
      extensions: [
        AppColors(
          borderLightColor: AppPallete.borderLightColorDark,
          borderNormalColor: AppPallete.borderNormalColorDark,
          borderDarkColor: AppPallete.borderDarkColorDark,
          deepTextColor: AppPallete.deepTextColorDark,
          darkTextColor: AppPallete.darkTextColorDark,
          normalTextColor: AppPallete.normalTextColorDark,
          lightTextColor: AppPallete.lightTextColorDark,
        ),
      ]);
}

class AppColors extends ThemeExtension<AppColors> {
  final Color borderLightColor;
  final Color borderNormalColor;
  final Color borderDarkColor;
  final Color deepTextColor;
  final Color darkTextColor;
  final Color normalTextColor;
  final Color lightTextColor;

  AppColors({
    required this.borderLightColor,
    required this.borderNormalColor,
    required this.borderDarkColor,
    required this.deepTextColor,
    required this.darkTextColor,
    required this.normalTextColor,
    required this.lightTextColor,
  });

  @override
  AppColors copyWith({
    Color? borderLightColor,
    Color? borderNormalColor,
    Color? borderDarkColor,
    Color? deepTextColor,
    Color? darkTextColor,
    Color? normalTextColor,
    Color? lightTextColor,
  }) {
    return AppColors(
      borderLightColor: borderLightColor ?? this.borderLightColor,
      borderNormalColor: borderNormalColor ?? this.borderNormalColor,
      borderDarkColor: borderDarkColor ?? this.borderDarkColor,
      deepTextColor: deepTextColor ?? this.deepTextColor,
      darkTextColor: darkTextColor ?? this.darkTextColor,
      normalTextColor: normalTextColor ?? this.normalTextColor,
      lightTextColor: lightTextColor ?? this.lightTextColor,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      borderLightColor:
          Color.lerp(borderLightColor, other.borderLightColor, t)!,
      borderNormalColor:
          Color.lerp(borderNormalColor, other.borderNormalColor, t)!,
      borderDarkColor: Color.lerp(borderDarkColor, other.borderDarkColor, t)!,
      deepTextColor: Color.lerp(deepTextColor, other.deepTextColor, t)!,
      darkTextColor: Color.lerp(darkTextColor, other.darkTextColor, t)!,
      normalTextColor: Color.lerp(normalTextColor, other.normalTextColor, t)!,
      lightTextColor: Color.lerp(lightTextColor, other.lightTextColor, t)!,
    );
  }
}
