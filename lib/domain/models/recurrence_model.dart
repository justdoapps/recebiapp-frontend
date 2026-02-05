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
  final TemplateModel? template;
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
      template: json['template'] != null ? TemplateModel.fromMap(json['template']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
