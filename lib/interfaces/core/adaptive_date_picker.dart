import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'platform_widget.dart'; // Sua classe abstrata

class AdaptiveDatePicker extends PlatformWidget<Widget, Widget> {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateChanged;

  const AdaptiveDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
  });

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return CalendarDatePicker(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      onDateChanged: onDateChanged,
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return SizedBox(
      height: 250,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: initialDate,
        minimumDate: firstDate,
        maximumDate: lastDate,
        onDateTimeChanged: onDateChanged,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
