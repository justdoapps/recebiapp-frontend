import 'package:flutter/material.dart';

import '../../../../domain/models/customer_model.dart';

class CustomerCardWidget extends StatelessWidget {
  const CustomerCardWidget({super.key, required this.customer});

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(customer.name),
        subtitle: Text(customer.phone ?? ''),
      ),
    );
  }
}
