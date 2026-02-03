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
    HomeKeysLang.dueDate: 'Due',
    HomeKeysLang.paidAt: 'Paid',
    HomeKeysLang.customerNote: 'Note for the customer',
    HomeKeysLang.internalNote: 'Internal observation only',
    HomeKeysLang.paymentInfo: 'Payment info',
    HomeKeysLang.description: 'Description',
    HomeKeysLang.confirmDeleteWarning:
        'This operation cannot be undone, the data will be deleted from your account. Canceling has the same effect but keeps the transaction data.',
    HomeKeysLang.confirmDelete: 'Do you want to delete this transaction?',
    HomeKeysLang.confirmClearFiles: 'Do you want to remove all files?',
    HomeKeysLang.clearAll: 'Clear all',
    HomeKeysLang.addFiles: 'Add files',
    HomeKeysLang.confirmRemoveFile: 'Do you want to remove the file {{fileName}}?',
    HomeKeysLang.selectDatePayment: 'Select payment date',
    HomeKeysLang.confirmCancelPayment: 'Do you want to cancel the payment and reopen the transaction?',
    HomeKeysLang.cancelAll: 'Cancel selected',
    HomeKeysLang.payAll: 'Pay selected',
    HomeKeysLang.confirmCancelAll: 'Do you want to cancel all {{quantity}} selected?',
    HomeKeysLang.invalidDayOfMonth: 'Invalid day',
    HomeKeysLang.invalidIntervalDays: 'Invalid interval',
    HomeKeysLang.newRecurrence: 'New recurrence',
    HomeKeysLang.newTransaction: 'New transaction',
    HomeKeysLang.templateRecurrence: 'Template recurrence',
    HomeKeysLang.recurrenceCreated: 'Recurrence created',
    HomeKeysLang.errorCreateRecurrence: 'Error creating recurrence',
    HomeKeysLang.startDate: 'Start date',
  };
}
