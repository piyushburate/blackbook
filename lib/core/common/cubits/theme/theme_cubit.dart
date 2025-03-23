import 'package:blackbook/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(super.initialThemeMode) {
    setStatusBarTheme();
  }

  void setTheme(ThemeMode themeMode) {
    if (themeMode != state) {
      emit(themeMode);
      _saveTheme(themeMode);
      setStatusBarTheme();
    }
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  void setStatusBarTheme() {
    if (state == ThemeMode.light) {
      SystemChrome.setSystemUIOverlayStyle(AppTheme.lightStatusBarTheme);
    }
    if (state == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(AppTheme.darkStatusBarTheme);
    }
    if (state == ThemeMode.system) {
      SystemChrome.setSystemUIOverlayStyle(
        isDarkMode ? AppTheme.darkStatusBarTheme : AppTheme.lightStatusBarTheme,
      );
    }
  }

  bool get isDarkMode {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  Future handleSystemUiOverlayStyle(Future showDialog) async {
    _setTransparentSystemUiOverlayStyle();
    final response = await showDialog;
    setStatusBarTheme();
    return response;
  }

  void _setTransparentSystemUiOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}
