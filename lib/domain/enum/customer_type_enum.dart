// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extension.dart';
import '../../interfaces/screens/customer/lang/customer_localization_ext.dart';

enum CustomerType {
  SUPPLIER,
  CUSTOMER,
  BOTH
  ;

  factory CustomerType.fromString(String? value) {
    if (value == null) return CustomerType.CUSTOMER;

    return CustomerType.values.firstWhere(
      (e) => e.name == value,
      orElse: () {
        return CustomerType.CUSTOMER;
      },
    );
  }

  String getCustomerTypeName(BuildContext context) {
    switch (this) {
      case CustomerType.SUPPLIER:
        return context.words.supplier;
      case CustomerType.CUSTOMER:
        return context.words.customer;
      case CustomerType.BOTH:
        return context.words.customerAndSupplier;
    }
  }
}
