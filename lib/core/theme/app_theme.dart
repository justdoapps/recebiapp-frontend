import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_texts.dart';

abstract final class AppTheme {
  static ThemeData lightTheme = defaultTheme.copyWith(
    colorScheme: AppColors.lightColorScheme,
    scaffoldBackgroundColor: AppColors.lightColorScheme.surface,
    extensions: [AppTexts.lightTypography],
    cardTheme: _cardTheme.copyWith(
      color: AppColors.lightColorScheme.surfaceContainer,
    ),
  );

  static ThemeData darkTheme = defaultTheme.copyWith(
    colorScheme: AppColors.darkColorScheme,
    scaffoldBackgroundColor: AppColors.darkColorScheme.surface,
    extensions: [AppTexts.darkTypography],
    cardTheme: _cardTheme.copyWith(
      color: AppColors.darkColorScheme.surfaceContainer,
    ),
  );

  static ThemeData defaultTheme = ThemeData(
    useMaterial3: true,
    textTheme: AppTexts.textTheme,
    inputDecorationTheme: _inputDecorationTheme,
    appBarTheme: _appBarTheme,
    navigationDrawerTheme: _navigationDrawerTheme,
    cardTheme: _cardTheme,
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

  static const _navigationDrawerTheme = NavigationDrawerThemeData(
    tileHeight: 45,
  );

  static const _cardTheme = CardThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: .all(.circular(18)),
    ),
  );
}
