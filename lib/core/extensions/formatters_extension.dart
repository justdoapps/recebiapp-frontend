import 'package:intl/intl.dart';

extension IntExtension on int {
  String toCurrency(String locale) {
    return NumberFormat.simpleCurrency(locale: locale, decimalDigits: 2).format(this / 100);
  }

  String centsToString() {
    return (this / 100).toStringAsFixed(2);
  }

  String bytesToMbString() {
    final double value = this / 1024 / 1024;
    return '${value.toStringAsFixed(2)}mb';
  }
}

extension StringExtension on String {
  int toCents() {
    if (isEmpty) return 0;
    final cleanString = replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanString) ?? 0;
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

  String toLocaleDayDateWithoutYear(String locale) {
    return DateFormat.MMMEd(locale).format(this);
  }

  String toMonthName(String locale) {
    return DateFormat.MMMM(locale).format(this);
  }
}
