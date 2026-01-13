import 'dart:convert';

import '../enum/customer_type_enum.dart';

class CustomerModel {
  final String id;
  final String name;
  final String? observation;
  final String? phone;
  final bool active;
  final CustomerType type;
  final String? document;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerModel({
    required this.id,
    required this.name,
    this.observation,
    this.phone,
    required this.active,
    required this.type,
    this.document,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'observation': observation,
      'phone': phone,
      'active': active,
      'type': type.name,
      'document': document,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      observation: map['observation'],
      phone: map['phone'],
      active: map['active'] ?? false,
      type: CustomerType.fromString(map['type']),
      document: map['document'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) => CustomerModel.fromMap(json.decode(source));

  CustomerModel copyWith({
    String? id,
    String? name,
    String? observation,
    String? phone,
    bool? active,
    CustomerType? type,
    String? document,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      observation: observation ?? this.observation,
      phone: phone ?? this.phone,
      active: active ?? this.active,
      type: type ?? this.type,
      document: document ?? this.document,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerModel &&
        other.id == id &&
        other.name == name &&
        other.observation == observation &&
        other.phone == phone &&
        other.active == active &&
        other.type == type &&
        other.document == document &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        observation.hashCode ^
        phone.hashCode ^
        active.hashCode ^
        type.hashCode ^
        document.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
