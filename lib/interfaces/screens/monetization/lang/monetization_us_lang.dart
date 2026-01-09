import 'monetization_keys_lang.dart';

abstract class MonetizationUsLang {
  static const words = <String, String>{
    MonetizationKeysLang.plans: 'Plans',
    MonetizationKeysLang.buy: 'Purchase',
    MonetizationKeysLang.buyAgain: 'Purchase again',
    MonetizationKeysLang.validUntil: 'Valid until',
    MonetizationKeysLang.cancelSubscription: 'Do you really want to cancel the subscription?',
    MonetizationKeysLang.paymentCanceled: 'Payment canceled',
    MonetizationKeysLang.paymentGenericError: 'Error processing payment',
    MonetizationKeysLang.getPlansFailed: 'Error fetching plans',
    MonetizationKeysLang.paymentSuccess: 'Payment processed',
    MonetizationKeysLang.createPaymentFailed: 'Error creating payment',
    MonetizationKeysLang.hasPlanActivated: 'Plan activated',
    MonetizationKeysLang.buyAgainConfirm: 'Do you really want to purchase again the annual plan?',
  };
}
