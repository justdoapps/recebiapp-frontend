import 'dart:convert';

class PlanModel {
  final String id;
  final String name;
  final String description;
  final int amountCents;
  final String interval;
  final int intervalCount;
  final String currency;

  PlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.amountCents,
    required this.interval,
    required this.intervalCount,
    required this.currency,
  });

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      amountCents: map['amountCents'] as int,
      interval: map['interval'] as String,
      intervalCount: map['intervalCount'] as int,
      currency: map['currency'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amountCents': amountCents,
      'interval': interval,
      'intervalCount': intervalCount,
      'currency': currency,
    };
  }

  String toJson() => json.encode(toMap());

  factory PlanModel.fromJson(String source) => PlanModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
