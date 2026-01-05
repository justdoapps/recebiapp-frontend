import 'dart:convert';

import '../enum/monetization_enum.dart';

class UserModel {
  final String name;
  final String email;
  final String token;
  final MonetizationPlan plan;
  final DateTime currentPeriodEnd;
  UserModel({
    required this.name,
    required this.email,
    required this.token,
    required this.plan,
    required this.currentPeriodEnd,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'token': token,
      'plan': plan.name,
      'trialEndsAt': currentPeriodEnd.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
      plan: MonetizationPlan.fromString(map['plan'] as String),
      currentPeriodEnd: DateTime.parse(map['currentPeriodEnd'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? name,
    String? email,
    String? token,
    MonetizationPlan? plan,
    DateTime? currentPeriodEnd,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      plan: plan ?? this.plan,
      currentPeriodEnd: currentPeriodEnd ?? this.currentPeriodEnd,
    );
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.token == token &&
        other.plan == plan &&
        other.currentPeriodEnd == currentPeriodEnd;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        token.hashCode ^
        plan.hashCode ^
        currentPeriodEnd.hashCode;
  }
}
