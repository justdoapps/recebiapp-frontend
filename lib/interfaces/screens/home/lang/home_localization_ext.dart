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
  String get confirmDelete => getWord(HomeKeysLang.confirmDelete);
  String get confirmDeleteWarning => getWord(HomeKeysLang.confirmDeleteWarning);
  String get selectDatePayment => getWord(HomeKeysLang.selectDatePayment);
  String get dueDate => getWord(HomeKeysLang.dueDate);
  String get paidAt => getWord(HomeKeysLang.paidAt);
  String get customerNote => getWord(HomeKeysLang.customerNote);
  String get internalNote => getWord(HomeKeysLang.internalNote);
  String get paymentInfo => getWord(HomeKeysLang.paymentInfo);
  String get description => getWord(HomeKeysLang.description);
  String get confirmClearFiles => getWord(HomeKeysLang.confirmClearFiles);
  String get clearAll => getWord(HomeKeysLang.clearAll);
  String get addFiles => getWord(HomeKeysLang.addFiles);
  String confirmRemoveFile(String fileName) =>
      getWord(HomeKeysLang.confirmRemoveFile).replaceAll('{{fileName}}', fileName);
  String get confirmCancelPayment => getWord(HomeKeysLang.confirmCancelPayment);
  String get cancelAll => getWord(HomeKeysLang.cancelAll);
  String get payAll => getWord(HomeKeysLang.payAll);
  String confirmCancelAll(int quantity) =>
      getWord(HomeKeysLang.confirmCancelAll).replaceAll('{{quantity}}', quantity.toString());
  String get invalidDayOfMonth => getWord(HomeKeysLang.invalidDayOfMonth);
  String get invalidIntervalDays => getWord(HomeKeysLang.invalidIntervalDays);
  String get newRecurrence => getWord(HomeKeysLang.newRecurrence);
  String get newTransaction => getWord(HomeKeysLang.newTransaction);
  String get templateRecurrence => getWord(HomeKeysLang.templateRecurrence);
  String get recurrenceCreated => getWord(HomeKeysLang.recurrenceCreated);
  String get errorCreateRecurrence => getWord(HomeKeysLang.errorCreateRecurrence);
  String get startDate => getWord(HomeKeysLang.startDate);
  String get errorListCustomers => getWord(HomeKeysLang.errorListCustomers);
  String get errorListTemplates => getWord(HomeKeysLang.errorListTemplates);
}
