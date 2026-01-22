import 'package:intl/intl.dart';

extension IntExtension on int {
  String toCurrency(String locale) {
    final double value = this / 100;
    return NumberFormat.simpleCurrency(locale: locale).format(value);
  }

  String centsToString(String locale) {
    final double value = this / 100;
    return NumberFormat.decimalPattern(locale).format(value);
  }

  String bytesToMegabytesString() {
    final double value = this / 1024 / 1024;
    return '${value.toStringAsFixed(2)}MB';
  }
}

extension StringExtension on String {
  int toCents() {
    if (isEmpty) return 0;
    final value = (double.tryParse(this) ?? 0.0);
    return (value * 100).round();
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
