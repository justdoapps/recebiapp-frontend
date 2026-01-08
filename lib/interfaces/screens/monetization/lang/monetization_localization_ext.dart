import '../../../../core/langs/app_localization.dart';
import 'monetization_keys_lang.dart';

extension MonetizationLocalization on AppLocalization {
  String get plans => getWord(MonetizationKeysLang.plans);
  String get buy => getWord(MonetizationKeysLang.buy);
  String get paymentCanceled => getWord(MonetizationKeysLang.paymentCanceled);
  String get paymentGenericError => getWord(MonetizationKeysLang.paymentGenericError);
  String get getPlansFailed => getWord(MonetizationKeysLang.getPlansFailed);
  String get paymentSuccess => getWord(MonetizationKeysLang.paymentSuccess);
  String get createPaymentFailed => getWord(MonetizationKeysLang.createPaymentFailed);
}
