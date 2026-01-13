import '../../../../core/langs/app_localization.dart';
import 'customer_keys_lang.dart';

extension CustomerLocalization on AppLocalization {
  String get errorGetCustomers => getWord(CustomerKeysLang.errorGetCustomers);
  String get noCustomersFound => getWord(CustomerKeysLang.noCustomersFound);
  String get newCustomer => getWord(CustomerKeysLang.newCustomer);
  String get editCustomer => getWord(CustomerKeysLang.editCustomer);
  // Name is already in AppLocalization
  String get document => getWord(CustomerKeysLang.document);
  String get phone => getWord(CustomerKeysLang.phone);
  String get observation => getWord(CustomerKeysLang.observation);
  String get type => getWord(CustomerKeysLang.type);
  // Supplier, Customer, Booth are already in AppLocalization but might need specifics if context differs.
  // The code uses context.words.supplier which exists in AppLocalization.
  String get save => getWord(CustomerKeysLang.save);
  String get errorCreateCustomer => getWord(CustomerKeysLang.errorCreateCustomer);
  String get customerCreated => getWord(CustomerKeysLang.customerCreated);
  String get errorUpdateCustomer => getWord(CustomerKeysLang.errorUpdateCustomer);
  String get customerUpdated => getWord(CustomerKeysLang.customerUpdated);
}
