import 'package:flutter/material.dart';

abstract final class AppColors {
  static const _seedColor = Colors.green;
  static final lightColorScheme = ColorScheme.fromSeed(seedColor: _seedColor);

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: .dark,
  );
}
