// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extension.dart';

enum TransactionType {
  INCOME,
  EXPENSE
  ;

  factory TransactionType.fromString(String? value) {
    if (value == null) return TransactionType.INCOME;

    try {
      return TransactionType.values.byName(value);
    } catch (_) {
      return TransactionType.INCOME;
    }
  }

  String getCustomerTypeName(BuildContext context) {
    switch (this) {
      case TransactionType.INCOME:
        return context.words.income;
      case TransactionType.EXPENSE:
        return context.words.expense;
    }
  }
}

enum TransactionStatus {
  PENDING,
  PAID,
  DUE_TODAY,
  OVERDUE,
  CANCELED
  ;

  factory TransactionStatus.fromString(String? value) {
    if (value == null) return TransactionStatus.PENDING;

    try {
      return TransactionStatus.values.byName(value);
    } catch (_) {
      return TransactionStatus.PENDING;
    }
  }

  String getCustomerTypeName(BuildContext context) {
    switch (this) {
      case TransactionStatus.PENDING:
        return context.words.pending;
      case TransactionStatus.PAID:
        return context.words.paid;
      case TransactionStatus.DUE_TODAY:
        return context.words.dueToday;
      case TransactionStatus.OVERDUE:
        return context.words.overdue;
      case TransactionStatus.CANCELED:
        return context.words.canceled;
    }
  }
}
