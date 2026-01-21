import '../enum/transaction_enum.dart';
import '../models/customer_model.dart';

class TransactionUpdateDto {
  final String id;
  final String? description;
  final int? amount;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final TransactionType? type;
  final TransactionStatus? status;
  final String? internalNote;
  final String? customerNote;
  final String? paymentInfo;
  final CustomerModel? customer;
  final String? recurrenceId;

  TransactionUpdateDto({
    required this.id,
    this.description,
    this.amount,
    this.dueDate,
    this.paidAt,
    this.type,
    this.status,
    this.internalNote,
    this.customerNote,
    this.paymentInfo,
    this.customer,
    this.recurrenceId,
  });

  Map<String, dynamic> toBodyRequest() {
    return <String, dynamic>{
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (dueDate != null) 'dueDate': dueDate,
      if (paidAt != null) 'paidAt': paidAt,
      if (type != null) 'type': type!.name,
      if (status != null) 'status': status!.name,
      if (internalNote != null) 'internalNote': internalNote,
      if (customerNote != null) 'customerNote': customerNote,
      if (paymentInfo != null) 'paymentInfo': paymentInfo,
      if (customer != null) 'customer': customer,
      if (recurrenceId != null) 'recurrenceId': recurrenceId,
    };
  }
}

class TransactionCreateDto {
  final String description;
  final int amount;
  final DateTime dueDate;
  final TransactionType type;
  final TransactionStatus status;
  final String? internalNote;
  final String? customerNote;
  final String? paymentInfo;
  final CustomerModel customer;

  TransactionCreateDto({
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.type,
    required this.status,
    this.internalNote,
    this.customerNote,
    this.paymentInfo,
    required this.customer,
  });

  Map<String, dynamic> toBodyRequest() {
    return <String, dynamic>{
      'description': description,
      'amount': amount,
      'dueDate': dueDate,
      'type': type.name,
      'status': status.name,
      if (internalNote != null) 'internalNote': internalNote,
      if (customerNote != null) 'customerNote': customerNote,
      if (paymentInfo != null) 'paymentInfo': paymentInfo,
      'customer': customer,
    };
  }
}
