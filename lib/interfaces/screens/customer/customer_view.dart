import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/dialog_extension.dart';
import '../../../core/extensions/message_extension.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../core/app_drawer.dart';
import 'components/upsert_customer_component.dart';
import 'customer_view_model.dart';
import 'lang/customer_localization_ext.dart';
import 'widgets/customer_card_widget.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> with LoadingMixin {
  late final CustomerViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<CustomerViewModel>();
    _vm.listCustomers.addListener(_listenerCommandListCustomers);
    _vm.listCustomers.execute();
  }

  @override
  void dispose() {
    _vm.listCustomers.removeListener(_listenerCommandListCustomers);
    super.dispose();
  }

  void _listenerCommandListCustomers() {
    _vm.listCustomers.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.listCustomers.error) {
      context.showMessage(
        title: context.words.errorGetCustomers,
        actionLabel: context.words.tryAgain,
        onAction: () {
          _vm.listCustomers.clearResult();
          _vm.listCustomers.execute();
        },
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.words.customers),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.showBottomSheet(
            child: Padding(
              padding: .only(bottom: context.viewInsetsBottom),
              child: ChangeNotifierProvider.value(
                value: _vm,
                child: const UpsertCustomerComponent(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _vm.listCustomers.execute(),
          child: Consumer<CustomerViewModel>(
            builder: (context, vm, child) {
              return vm.customers.isEmpty
                  ? Center(
                      child: Text(context.words.noCustomersFound),
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CustomerCardWidget(customer: vm.customers[index]);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: vm.customers.length,
                    );
            },
          ),
        ),
      ),
    );
  }
}
