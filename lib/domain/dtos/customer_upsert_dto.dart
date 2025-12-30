import 'dart:convert';

class CustomerUpdateDto {
  final String? name;
  final String? observation;
  final String? phone;
  final String? timezone;
  final bool? active;

  CustomerUpdateDto({
    this.name,
    this.observation,
    this.phone,
    this.timezone,
    this.active,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'observation': observation,
      'phone': phone,
      'timezone': timezone,
      'active': active,
    };
  }

  factory CustomerUpdateDto.fromMap(Map<String, dynamic> map) {
    return CustomerUpdateDto(
      name: map['name'] as String?,
      observation: map['observation'] as String?,
      phone: map['phone'] as String?,
      timezone: map['timezone'] as String?,
      active: map['active'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerUpdateDto.fromJson(String source) =>
      CustomerUpdateDto.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CustomerCreateDto extends CustomerUpdateDto {
  CustomerCreateDto({
    required String super.name,
    super.observation,
    super.phone,
    required String super.timezone,
    super.active = true,
  });
}
