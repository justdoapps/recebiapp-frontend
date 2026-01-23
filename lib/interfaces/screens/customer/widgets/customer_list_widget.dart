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
    return RefreshIndicator(
      onRefresh: vm.listCustomers.execute,
      child: CustomScrollView(
        slivers: customers.isEmpty
            ? [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(context.words.noCustomersFound, style: context.textTheme.large),
                  ),
                ),
              ]
            : [
                SliverList.separated(
                  itemBuilder: (context, index) {
                    return CustomerCardWidget(customer: customers[index], vm: vm);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: customers.length,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
      ),
    );
  }
}
