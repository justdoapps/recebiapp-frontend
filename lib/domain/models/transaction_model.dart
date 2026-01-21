import 'dart:convert';

import '../enum/transaction_enum.dart';
import 'customer_model.dart';

class TransactionModel {
  final String id;
  final String description;
  final int amount;
  final DateTime dueDate;
  final DateTime? paidAt;
  final TransactionType type;
  final TransactionStatus status;
  final String? internalNote;
  final String? customerNote;
  final String? paymentInfo;
  final CustomerModel customer;
  final String? recurrenceId; //TODO mudar qnd tiver o objeto recurrence
  //todo adicionar objeto anexos attachment
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    this.paidAt,
    required this.type,
    required this.status,
    this.internalNote,
    this.customerNote,
    this.paymentInfo,
    required this.customer,
    this.recurrenceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
      dueDate: DateTime.parse(json['dueDate']),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      type: json['type'],
      status: json['status'],
      internalNote: json['internalNote'],
      customerNote: json['customerNote'],
      paymentInfo: json['paymentInfo'],
      customer: CustomerModel.fromJson(json['customer']),
      recurrenceId: json['recurrenceId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'type': type,
      'status': status,
      'internalNote': internalNote,
      'customerNote': customerNote,
      'paymentInfo': paymentInfo,
      'customer': customer.toJson(),
      'recurrenceId': recurrenceId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) => TransactionModel.fromMap(json.decode(source));

  TransactionModel copyWith({
    String? id,
    String? description,
    int? amount,
    DateTime? dueDate,
    DateTime? paidAt,
    TransactionType? type,
    TransactionStatus? status,
    String? internalNote,
    String? customerNote,
    String? paymentInfo,
    CustomerModel? customer,
    String? recurrenceId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      paidAt: paidAt ?? this.paidAt,
      type: type ?? this.type,
      status: status ?? this.status,
      internalNote: internalNote ?? this.internalNote,
      customerNote: customerNote ?? this.customerNote,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      customer: customer ?? this.customer,
      recurrenceId: recurrenceId ?? this.recurrenceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel &&
        other.id == id &&
        other.description == description &&
        other.amount == amount &&
        other.dueDate == dueDate &&
        other.paidAt == paidAt &&
        other.type == type &&
        other.status == status &&
        other.internalNote == internalNote &&
        other.customerNote == customerNote &&
        other.paymentInfo == paymentInfo &&
        other.customer == customer &&
        other.recurrenceId == recurrenceId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        dueDate.hashCode ^
        paidAt.hashCode ^
        type.hashCode ^
        status.hashCode ^
        internalNote.hashCode ^
        customerNote.hashCode ^
        paymentInfo.hashCode ^
        customer.hashCode ^
        recurrenceId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
