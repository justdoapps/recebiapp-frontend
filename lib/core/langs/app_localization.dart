import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../interfaces/screens/auth/lang/auth_pt_lang.dart';
import '../../interfaces/screens/auth/lang/auth_us_lang.dart';
import 'keys_lang.dart';
import 'pt_lang.dart';
import 'us_lang.dart';

class AppLocalization {
  final Locale locale;
  late final Map<String, String> _strings;

  AppLocalization(this.locale) {
    switch (locale.languageCode) {
      case 'pt':
        _strings = {...PtLang.words, ...AuthPtLang.words};
        break;
      case 'en':
      default:
        _strings = {...UsLang.words, ...AuthUsLang.words};
    }
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }

  String getWord(String label) => _strings[label] ?? '[${label.toUpperCase()}]';

  String get tryAgain => getWord(KeysLang.tryAgain);
  String get appName => getWord(KeysLang.appName);
  String get home => getWord(KeysLang.home);
  String get logout => getWord(KeysLang.logout);
  String get themeMode => getWord(KeysLang.themeMode);
  String get darkMode => getWord(KeysLang.darkMode);
  String get lightMode => getWord(KeysLang.lightMode);
  String get appDescription => getWord(KeysLang.appDescription);
  String get back => getWord(KeysLang.back);
  String get email => getWord(KeysLang.email);
  String get password => getWord(KeysLang.password);
  String get confirmPassword => getWord(KeysLang.confirmPassword);
  String get name => getWord(KeysLang.name);
  String get or => getWord(KeysLang.or);
  String get requiredField => getWord(KeysLang.requiredField);
  String get invalidEmail => getWord(KeysLang.invalidEmail);
  String minLength(int min) =>
      getWord(KeysLang.minLength).replaceAll('{min}', min.toString());
  String get passwordsDontMatch => getWord(KeysLang.passwordsDontMatch);
  String get cancel => getWord(KeysLang.cancel);
  String get confirm => getWord(KeysLang.confirm);

  // String nameTrips(String name) => _get('nameTrips').replaceAll('{name}', name);
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) => ['en', 'pt'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture(AppLocalization(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}
