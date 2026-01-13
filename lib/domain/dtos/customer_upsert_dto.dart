import '../enum/customer_type_enum.dart';

class CustomerUpdateDto {
  final String id;
  final String? name;
  final String? observation;
  final String? phone;
  final bool? active;
  final CustomerType? type;
  final String? document;

  CustomerUpdateDto({
    required this.id,
    this.name,
    this.observation,
    this.phone,
    this.active,
    this.type,
    this.document,
  });

  Map<String, dynamic> toBodyRequest() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (observation != null) 'observation': observation,
      if (phone != null) 'phone': phone,
      if (active != null) 'active': active,
      if (type != null) 'type': type!.name,
      if (document != null) 'document': document,
    };
  }
}

class CustomerCreateDto {
  final String name;
  final String? observation;
  final String? phone;
  final CustomerType type;
  final String? document;

  CustomerCreateDto({
    required this.name,
    this.observation,
    this.phone,
    required this.type,
    this.document,
  });

  Map<String, dynamic> toBodyRequest() {
    return <String, dynamic>{
      'name': name,
      if (observation != null) 'observation': observation,
      if (phone != null) 'phone': phone,
      'active': true,
      'type': type.name,
      if (document != null) 'document': document,
    };
  }
}
