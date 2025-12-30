import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_texts.dart';

abstract final class AppTheme {
  static ThemeData lightTheme = defaultTheme.copyWith(
    colorScheme: AppColors.lightColorScheme,
    scaffoldBackgroundColor: AppColors.lightColorScheme.surface,
    extensions: [AppTexts.lightTypography],
  );

  static ThemeData darkTheme = defaultTheme.copyWith(
    colorScheme: AppColors.darkColorScheme,
    scaffoldBackgroundColor: AppColors.darkColorScheme.surface,
    extensions: [AppTexts.darkTypography],
  );

  static ThemeData defaultTheme = ThemeData(
    useMaterial3: true,
    textTheme: AppTexts.textTheme,
    inputDecorationTheme: _inputDecorationTheme,
    appBarTheme: _appBarTheme,
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(fontWeight: .bold),
    isCollapsed: true,
    isDense: true,
    filled: true,
    border: OutlineInputBorder(),
    floatingLabelAlignment: .center,
    floatingLabelBehavior: .always,
    labelStyle: TextStyle(fontWeight: .bold),
    floatingLabelStyle: TextStyle(fontWeight: .bold),
    contentPadding: EdgeInsets.zero,
    errorStyle: TextStyle(fontSize: 11, fontStyle: .italic),
  );

  static const _appBarTheme = AppBarTheme(centerTitle: true);
}
