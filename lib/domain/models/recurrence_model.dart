import '../enum/frequency_enum.dart';
import '../enum/transaction_enum.dart';
import 'customer_model.dart';
import 'template_model.dart';

class RecurrenceModel {
  final String id;
  final String description;
  final int amount;
  final bool isActive;
  final DateTime startDate;
  final DateTime nextRunDate;
  final TransactionType type;
  final Frequency frequency;
  final int? intervalDays;
  final int? dayOfMonth;
  final int? dayOfWeek;
  final CustomerModel customer;
  final TemplateModel template;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecurrenceModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.isActive,
    required this.startDate,
    required this.nextRunDate,
    required this.type,
    required this.frequency,
    required this.intervalDays,
    required this.dayOfMonth,
    required this.dayOfWeek,
    required this.customer,
    required this.template,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecurrenceModel.fromMap(Map<String, dynamic> json) {
    return RecurrenceModel(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
      isActive: json['isActive'],
      startDate: DateTime.parse(json['startDate']),
      nextRunDate: DateTime.parse(json['nextRunDate']),
      type: TransactionType.fromString(json['type'] as String),
      frequency: Frequency.fromString(json['frequency'] as String),
      intervalDays: json['intervalDays'],
      dayOfMonth: json['dayOfMonth'],
      dayOfWeek: json['dayOfWeek'],
      customer: CustomerModel.fromMap(json['customer']),
      template: TemplateModel.fromMap(json['template']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'isActive': isActive,
      'startDate': startDate.toIso8601String(),
      'nextRunDate': nextRunDate.toIso8601String(),
      'type': type.name,
      'frequency': frequency.name,
      'intervalDays': intervalDays,
      'dayOfMonth': dayOfMonth,
      'dayOfWeek': dayOfWeek,
      'customer': customer.toMap(),
      'template': template.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  RecurrenceModel copyWith({
    String? id,
    String? description,
    int? amount,
    bool? isActive,
    DateTime? startDate,
    DateTime? nextRunDate,
    TransactionType? type,
    Frequency? frequency,
    int? intervalDays,
    int? dayOfMonth,
    int? dayOfWeek,
    CustomerModel? customer,
    TemplateModel? template,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecurrenceModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      nextRunDate: nextRunDate ?? this.nextRunDate,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      intervalDays: intervalDays ?? this.intervalDays,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      customer: customer ?? this.customer,
      template: template ?? this.template,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecurrenceModel &&
        other.id == id &&
        other.description == description &&
        other.amount == amount &&
        other.isActive == isActive &&
        other.startDate == startDate &&
        other.nextRunDate == nextRunDate &&
        other.type == type &&
        other.frequency == frequency &&
        other.intervalDays == intervalDays &&
        other.dayOfMonth == dayOfMonth &&
        other.dayOfWeek == dayOfWeek &&
        other.customer == customer &&
        other.template == template &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        isActive.hashCode ^
        startDate.hashCode ^
        nextRunDate.hashCode ^
        type.hashCode ^
        frequency.hashCode ^
        intervalDays.hashCode ^
        dayOfMonth.hashCode ^
        dayOfWeek.hashCode ^
        customer.hashCode ^
        template.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
