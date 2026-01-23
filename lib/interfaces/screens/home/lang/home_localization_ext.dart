import '../../../../core/langs/app_localization.dart';
import 'home_keys_lang.dart';

extension HomeLocalization on AppLocalization {
  String get errorGetTransactions => getWord(HomeKeysLang.errorGetTransactions);
  String get noTransactionsFound => getWord(HomeKeysLang.noTransactionsFound);
  String get errorCreateTransaction => getWord(HomeKeysLang.errorCreateTransaction);
  String get transactionCreated => getWord(HomeKeysLang.transactionCreated);
  String get errorUpdateTransaction => getWord(HomeKeysLang.errorUpdateTransaction);
  String get transactionUpdated => getWord(HomeKeysLang.transactionUpdated);
  String get amount => getWord(HomeKeysLang.amount);
  String get dueDate => getWord(HomeKeysLang.dueDate);
  String get customerNote => getWord(HomeKeysLang.customerNote);
  String get internalNote => getWord(HomeKeysLang.internalNote);
  String get paymentInfo => getWord(HomeKeysLang.paymentInfo);
  String get description => getWord(HomeKeysLang.description);
  String get confirmClearFiles => getWord(HomeKeysLang.confirmClearFiles);
  String get clearAll => getWord(HomeKeysLang.clearAll);
  String get addFiles => getWord(HomeKeysLang.addFiles);
  String confirmRemoveFile(String fileName) =>
      getWord(HomeKeysLang.confirmRemoveFile).replaceAll('{{fileName}}', fileName);
}
