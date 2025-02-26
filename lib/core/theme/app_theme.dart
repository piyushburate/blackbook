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

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    fontFamily: appFontFamily,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppPallete.primaryColor,
      onPrimary: Colors.white,
      secondary: AppPallete.primaryColor,
      onSecondary: Colors.white,
      error: AppPallete.errorColor,
      onError: Colors.white,
      surface: AppPallete.surfaceColor,
      onSurface: AppPallete.darkTextColor,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      surfaceTintColor: AppPallete.backgroundColor,
      foregroundColor: AppPallete.darkTextColor,
      toolbarHeight: 80,
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
      unselectedLabelColor: AppPallete.lightTextColor,
    ),
  );

  static void setLightStatusBarTheme() => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: AppPallete.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppPallete.backgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
}
