import 'package:flutter/material.dart';

import 'data/services/preferences_service.dart';

class SettingsController extends ChangeNotifier {
  final PreferencesService _service;

  late ThemeMode _themeMode;
  late Locale? _locale;

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;

  SettingsController({
    required PreferencesService service,
    required ThemeMode initialTheme,
    required Locale? initialLocale,
  }) : _service = service {
    _themeMode = initialTheme;
    _locale = initialLocale;
  }

  void updateThemeMode(ThemeMode? newMode) {
    if (newMode == null || newMode == _themeMode) return;

    _themeMode = newMode;
    notifyListeners();
    _service.saveThemeMode(newMode);
  }

  void updateLocale(Locale? newLocale) {
    if (newLocale == _locale) return;

    _locale = newLocale;
    notifyListeners();
    if (newLocale != null) {
      _service.saveLocale(newLocale);
    }
  }
}
