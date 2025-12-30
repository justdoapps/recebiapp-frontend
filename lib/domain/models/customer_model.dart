import 'dart:convert';

class CustomerModel {
  final String id;
  final String name;
  final String observation;
  final String phone;
  final String timezone;
  final bool active;

  CustomerModel({
    required this.id,
    required this.name,
    required this.observation,
    required this.phone,
    required this.timezone,
    required this.active,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'observation': observation,
      'phone': phone,
      'timezone': timezone,
      'active': active,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      observation: map['observation'] ?? '',
      phone: map['phone'] ?? '',
      timezone: map['timezone'] ?? '',
      active: map['active'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source));

  CustomerModel copyWith({
    String? id,
    String? name,
    String? observation,
    String? phone,
    String? timezone,
    bool? active,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      observation: observation ?? this.observation,
      phone: phone ?? this.phone,
      timezone: timezone ?? this.timezone,
      active: active ?? this.active,
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
        other.timezone == timezone &&
        other.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        observation.hashCode ^
        phone.hashCode ^
        timezone.hashCode ^
        active.hashCode;
  }
}
