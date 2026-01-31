import '../enum/frequency_enum.dart';
import '../enum/transaction_enum.dart';

class TemplateCreateDto {
  final String name;
  final int amount;
  final int? intervalDays;
  final int? dayOfMonth;
  final int? dayOfWeek;
  final Frequency frequency;
  final TransactionType type;

  TemplateCreateDto({
    required this.name,
    required this.amount,
    required this.intervalDays,
    required this.dayOfMonth,
    required this.dayOfWeek,
    required this.frequency,
    required this.type,
  });

  Map<String, dynamic> toBodyRequest() {
    return <String, dynamic>{
      'name': name,
      'amount': amount,
      if (intervalDays != null) 'intervalDays': intervalDays,
      if (dayOfMonth != null) 'dayOfMonth': dayOfMonth,
      if (dayOfWeek != null) 'dayOfWeek': dayOfWeek,
      'frequency': frequency.name,
      'type': type.name,
    };
  }
}

class TemplateUpdateDto {
  final String id;
  final String? name;
  final int? amount;
  final int? intervalDays;
  final int? dayOfMonth;
  final int? dayOfWeek;
  final Frequency? frequency;
  final TransactionType? type;
  final bool? active;

  TemplateUpdateDto({
    required this.id,
    this.name,
    this.amount,
    this.intervalDays,
    this.dayOfMonth,
    this.dayOfWeek,
    this.frequency,
    this.type,
    this.active,
  });

  Map<String, dynamic> toBodyRequest() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (intervalDays != null) 'intervalDays': intervalDays,
      if (dayOfMonth != null) 'dayOfMonth': dayOfMonth,
      if (dayOfWeek != null) 'dayOfWeek': dayOfWeek,
      if (frequency != null) 'frequency': frequency!.name,
      if (type != null) 'type': type!.name,
      if (active != null) 'active': active,
    };
  }
}
