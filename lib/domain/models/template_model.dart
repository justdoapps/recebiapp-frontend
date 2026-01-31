import '../enum/frequency_enum.dart';
import '../enum/transaction_enum.dart';

class TemplateModel {
  final String id;
  final String name;
  final int amount;
  final int? intervalDays;
  final int? dayOfMonth;
  final int? dayOfWeek;
  final Frequency frequency;
  // final List<> recurrences;
  final TransactionType type;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  TemplateModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.intervalDays,
    required this.dayOfMonth,
    required this.dayOfWeek,
    required this.frequency,
    required this.type,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TemplateModel.fromMap(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      intervalDays: json['intervalDays'],
      dayOfMonth: json['dayOfMonth'],
      dayOfWeek: json['dayOfWeek'],
      frequency: Frequency.fromString(json['frequency'] as String),
      type: TransactionType.fromString(json['type'] as String),
      active: json['active'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'intervalDays': intervalDays,
      'dayOfMonth': dayOfMonth,
      'dayOfWeek': dayOfWeek,
      'frequency': frequency,
      'type': type,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TemplateModel copyWith({
    String? id,
    String? name,
    int? amount,
    int? intervalDays,
    int? dayOfMonth,
    int? dayOfWeek,
    Frequency? frequency,
    TransactionType? type,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      intervalDays: intervalDays ?? this.intervalDays,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      frequency: frequency ?? this.frequency,
      type: type ?? this.type,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TemplateModel &&
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.intervalDays == intervalDays &&
        other.dayOfMonth == dayOfMonth &&
        other.dayOfWeek == dayOfWeek &&
        other.frequency == frequency &&
        other.type == type &&
        other.active == active &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        amount.hashCode ^
        intervalDays.hashCode ^
        dayOfMonth.hashCode ^
        dayOfWeek.hashCode ^
        frequency.hashCode ^
        type.hashCode ^
        active.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
