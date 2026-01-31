// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extension.dart';

enum Frequency {
  INTERVAL,
  MONTHLY,
  WEEKLY
  ;

  factory Frequency.fromString(String? value) {
    if (value == null) return Frequency.INTERVAL;

    try {
      return Frequency.values.byName(value);
    } catch (_) {
      return Frequency.INTERVAL;
    }
  }

  String getContextName(BuildContext context) {
    switch (this) {
      case Frequency.INTERVAL:
        return context.words.interval;
      case Frequency.MONTHLY:
        return context.words.monthly;
      case Frequency.WEEKLY:
        return context.words.weekly;
    }
  }
}

enum FrequencyWeekly {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY
  ;

  factory FrequencyWeekly.fromInt(int value) {
    switch (value) {
      case 0:
        return FrequencyWeekly.MONDAY;
      case 1:
        return FrequencyWeekly.TUESDAY;
      case 2:
        return FrequencyWeekly.WEDNESDAY;
      case 3:
        return FrequencyWeekly.THURSDAY;
      case 4:
        return FrequencyWeekly.FRIDAY;
      case 5:
        return FrequencyWeekly.SATURDAY;
      case 6:
        return FrequencyWeekly.SUNDAY;
      default:
        return FrequencyWeekly.MONDAY;
    }
  }

  String getContextName(BuildContext context) {
    switch (this) {
      case FrequencyWeekly.MONDAY:
        return context.words.monday;
      case FrequencyWeekly.TUESDAY:
        return context.words.tuesday;
      case FrequencyWeekly.WEDNESDAY:
        return context.words.wednesday;
      case FrequencyWeekly.THURSDAY:
        return context.words.thursday;
      case FrequencyWeekly.FRIDAY:
        return context.words.friday;
      case FrequencyWeekly.SATURDAY:
        return context.words.saturday;
      case FrequencyWeekly.SUNDAY:
        return context.words.sunday;
    }
  }

  int getInt() {
    switch (this) {
      case FrequencyWeekly.MONDAY:
        return 0;
      case FrequencyWeekly.TUESDAY:
        return 1;
      case FrequencyWeekly.WEDNESDAY:
        return 2;
      case FrequencyWeekly.THURSDAY:
        return 3;
      case FrequencyWeekly.FRIDAY:
        return 4;
      case FrequencyWeekly.SATURDAY:
        return 5;
      case FrequencyWeekly.SUNDAY:
        return 6;
    }
  }
}
