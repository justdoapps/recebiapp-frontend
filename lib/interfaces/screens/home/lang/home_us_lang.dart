import 'home_keys_lang.dart';

abstract class HomeUsLang {
  static const words = <String, String>{
    HomeKeysLang.errorGetTransactions: 'Error getting transactions',
    HomeKeysLang.noTransactionsFound: 'No transactions found',
    HomeKeysLang.errorCreateTransaction: 'Error creating transaction',
    HomeKeysLang.transactionCreated: 'Transaction created',
    HomeKeysLang.errorUpdateTransaction: 'Error updating transaction',
    HomeKeysLang.transactionUpdated: 'Transaction updated',
    HomeKeysLang.amount: 'Amount',
    HomeKeysLang.dueDate: 'Due date',
    HomeKeysLang.customerNote: 'Note for the customer',
    HomeKeysLang.internalNote: 'Internal observation only',
    HomeKeysLang.paymentInfo: 'Payment info',
    HomeKeysLang.description: 'Description',
    HomeKeysLang.confirmClearFiles: 'Do you want to remove all files?',
    HomeKeysLang.clearAll: 'Clear all',
    HomeKeysLang.addFiles: 'Add files',
    HomeKeysLang.confirmRemoveFile: 'Do you want to remove the file {{fileName}}?',
  };
}
