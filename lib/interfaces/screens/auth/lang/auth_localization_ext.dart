import '../../../../core/langs/app_localization.dart';
import 'auth_keys_lang.dart';

extension AuthLocalization on AppLocalization {
  String get loginServerFailed => getWord(AuthKeysLang.loginServerFailed);
  String get loginFailed => getWord(AuthKeysLang.loginFailed);
  String get forgotPassword => getWord(AuthKeysLang.forgotPassword);
  String get sendRecoverLink => getWord(AuthKeysLang.sendRecoverLink);
  String get recoverPassword => getWord(AuthKeysLang.recoverPassword);
  String get createAccount => getWord(AuthKeysLang.createAccount);
  String get login => getWord(AuthKeysLang.login);
  String get alreadyHaveAccount => getWord(AuthKeysLang.alreadyHaveAccount);
  String get credentialsInvalid => getWord(AuthKeysLang.credentialsInvalid);
  String get registerSuccess => getWord(AuthKeysLang.registerSuccess);
  String get registerFailed => getWord(AuthKeysLang.registerFailed);
}
