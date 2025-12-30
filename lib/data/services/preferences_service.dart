import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/result.dart';
import '../../domain/models/user_model.dart';

class PreferencesService {
  final SharedPreferences _prefs;
  final _log = Logger('PreferencesService');
  final _userController = StreamController<UserModel?>.broadcast();
  Stream<UserModel?> get onUserChanged => _userController.stream;

  PreferencesService(this._prefs);

  Future<Result<UserModel?>> getUser() async {
    try {
      final userJson = _prefs.getString('user');
      return userJson == null
          ? const Result.ok(null)
          : Result.ok(UserModel.fromJson(userJson));
    } on Exception catch (e) {
      _log.warning('Erro ao pegar User do SharedPreferences', e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveUser(UserModel? user) async {
    try {
      if (user == null) {
        await _prefs.remove('user');
      } else {
        await _prefs.setString('user', user.toJson());
      }
      _userController.add(user);
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Erro ao salvar User no SharedPreferences', e);
      return Result.error(e);
    }
  }

  ThemeMode getThemeMode() {
    try {
      final savedValue = _prefs.getString('theme');
      if (savedValue == null) return ThemeMode.system;
      return ThemeMode.values.firstWhere(
        (e) => e.name == savedValue,
        orElse: () => ThemeMode.system,
      );
    } on Exception catch (e) {
      _log.warning('Erro ao pegar Theme do SharedPreferences', e);
      return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString('theme', mode.name);
  }

  Locale? getLocale() {
    final savedCode = _prefs.getString('locale');
    if (savedCode == null) return null;

    final parts = savedCode.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }

  Future<void> saveLocale(Locale locale) async {
    final code = locale.countryCode != null
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    await _prefs.setString('locale', code);
  }
}
