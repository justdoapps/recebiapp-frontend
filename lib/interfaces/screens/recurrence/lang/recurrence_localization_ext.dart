import '../../../../core/langs/app_localization.dart';
import 'recurrence_keys_lang.dart';

extension RecurrenceLocalization on AppLocalization {
  String get errorGetRecurrences => getWord(RecurrenceKeysLang.errorGetRecurrences);
  String get noRecurrencesFound => getWord(RecurrenceKeysLang.noRecurrencesFound);
  String get recurrences => getWord(RecurrenceKeysLang.recurrences);
  String get errorCreateRecurrence => getWord(RecurrenceKeysLang.errorCreateRecurrence);
  String get errorUpdateRecurrence => getWord(RecurrenceKeysLang.errorUpdateRecurrence);
  String get recurrenceCreated => getWord(RecurrenceKeysLang.recurrenceCreated);
  String get recurrenceUpdated => getWord(RecurrenceKeysLang.recurrenceUpdated);
}
