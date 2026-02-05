import '../enum/frequency_enum.dart';
import '../enum/transaction_enum.dart';

class RecurrenceCreateDto {
  final String description;
  final int amount;
  final DateTime startDate;
  final TransactionType type;
  final Frequency frequency;
  final int? intervalDays;
  final int? dayOfMonth;
  final int? dayOfWeek;
  final String customerId;
  final String? templateId;

  RecurrenceCreateDto({
    required this.description,
    required this.amount,
    required this.startDate,
    required this.type,
    required this.frequency,
    this.intervalDays,
    this.dayOfMonth,
    this.dayOfWeek,
    required this.customerId,
    this.templateId,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amount': amount,
      'startDate': startDate.toIso8601String(),
      'type': type.name,
      'frequency': frequency.name,
      if (intervalDays != null) 'intervalDays': intervalDays,
      if (dayOfMonth != null) 'dayOfMonth': dayOfMonth,
      if (dayOfWeek != null) 'dayOfWeek': dayOfWeek,
      'customerId': customerId,
      if (templateId != null) 'templateId': templateId,
    };
  }
}

class RecurrenceUpdateDto {
  final String id;
  final String? description;
  final int? amount;
  final DateTime? startDate;
  final TransactionType? type;
  final Frequency? frequency;
  final int? intervalDays;
  final int? dayOfMonth;
  final int? dayOfWeek;
  final String? customerId;
  final String? templateId;
  final bool? isActive;

  RecurrenceUpdateDto({
    required this.id,
    this.description,
    this.amount,
    this.startDate,
    this.type,
    this.frequency,
    this.intervalDays,
    this.dayOfMonth,
    this.dayOfWeek,
    this.customerId,
    this.templateId,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (type != null) 'type': type!.name,
      if (frequency != null) 'frequency': frequency!.name,
      if (intervalDays != null) 'intervalDays': intervalDays,
      if (dayOfMonth != null) 'dayOfMonth': dayOfMonth,
      if (dayOfWeek != null) 'dayOfWeek': dayOfWeek,
      if (customerId != null) 'customerId': customerId,
      if (templateId != null) 'templateId': templateId,
      if (isActive != null) 'isActive': isActive,
    };
  }
}
