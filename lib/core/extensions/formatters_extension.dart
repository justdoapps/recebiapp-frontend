import 'package:intl/intl.dart';

extension CurrencyExtension on int {
  String toCurrency(String locale) {
    final double value = this / 100.0;
    return NumberFormat.simpleCurrency(locale: locale).format(value);
  }

  String toDecimalPattern(String locale) {
    final double value = this / 100.0;
    return NumberFormat.decimalPattern(locale).format(value);
  }
}

extension DateExtension on DateTime {
  String toLocaleDate(String locale) {
    return DateFormat.yMd(locale).format(this);
  }

  String toLocaleDateTime(String locale) {
    return DateFormat.yMd(locale).add_Hm().format(this);
  }

  String toLocaleDayDateTime(String locale) {
    return DateFormat.yMMMEd(locale).add_Hm().format(this);
  }

  String toLocaleDayDate(String locale) {
    return DateFormat.yMMMEd(locale).format(this);
  }

  String toMonthName(String locale) {
    return DateFormat.MMMM(locale).format(this);
  }
}
