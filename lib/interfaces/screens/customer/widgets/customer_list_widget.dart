import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../domain/enum/customer_type_enum.dart';
import '../customer_view_model.dart';
import '../lang/customer_localization_ext.dart';
import 'customer_card_widget.dart';

class CustomerListWidget extends StatelessWidget {
  const CustomerListWidget({super.key, required this.vm, this.type});

  final CustomerViewModel vm;
  final CustomerType? type;

  @override
  Widget build(BuildContext context) {
    final customers = switch (type) {
      CustomerType.CUSTOMER => vm.typeCustomer,
      CustomerType.SUPPLIER => vm.typeSupplier,
      CustomerType.BOTH => vm.typeBoth,
      null => vm.customers,
    };
    return customers.isEmpty
        ? Center(
            child: Text(context.words.noCustomersFound, style: context.textTheme.large),
          )
        : ListView.separated(
            padding: const EdgeInsets.only(bottom: 80),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CustomerCardWidget(customer: customers[index], vm: vm);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: customers.length,
          );
  }
}
