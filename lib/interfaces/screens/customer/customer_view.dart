import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/dialog_extension.dart';
import '../../../core/extensions/message_extension.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/utils/throttler.dart';
import '../../../domain/enum/customer_type_enum.dart';
import '../../core/app_drawer.dart';
import '../../core/app_search_bar.dart';
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
  final TextEditingController _searchEC = TextEditingController();
  final Debouncer _searchDebouncer = Debouncer(const Duration(milliseconds: 300));
  final Throttler _clearThrottler = Throttler(const Duration(milliseconds: 500));

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
    _searchEC.dispose();
    _searchDebouncer.cancel();
    _clearThrottler.cancel();
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

  Widget _buildCustomerList(CustomerType? type) {
    final customers = switch (type) {
      CustomerType.CUSTOMER => _vm.typeCustomer,
      CustomerType.SUPPLIER => _vm.typeSupplier,
      CustomerType.BOTH => _vm.typeBoth,
      null => _vm.customers,
    };
    return customers.isEmpty
        ? Center(
            child: Text(context.words.noCustomersFound, style: context.textTheme.large),
          )
        : ListView.separated(
            padding: const EdgeInsets.only(bottom: 80),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CustomerCardWidget(customer: customers[index], vm: _vm);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: customers.length,
          );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [context.words.all, context.words.customer, context.words.supplier, context.words.both];
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.words.customerAndSupplier),
          bottom: TabBar(
            tabAlignment: .center,
            indicatorSize: .tab,
            overlayColor: .all(Colors.transparent),
            dividerHeight: 0,
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        drawer: const AppDrawer(),
        floatingActionButtonLocation: .centerDocked,
        floatingActionButton: FloatingActionButton.extended(
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
          icon: const Icon(Icons.add),
          label: Text(context.words.newData),
        ),
        body: RefreshIndicator(
          onRefresh: () => _vm.listCustomers.execute(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Consumer<CustomerViewModel>(
              builder: (_, _, _) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AppSearchBar(
                        hintText: context.words.searchCustomers,
                        onChanged: (value) => _searchDebouncer.run(() => _vm.filterCustomers(query: value)),
                        onClear: () {
                          _clearThrottler.run(() {
                            _searchEC.clear();
                            _searchDebouncer.cancel();
                            _vm.filterCustomers();
                          });
                        },
                        controller: _searchEC,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          _buildCustomerList(null),
                          _buildCustomerList(CustomerType.CUSTOMER),
                          _buildCustomerList(CustomerType.SUPPLIER),
                          _buildCustomerList(CustomerType.BOTH),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
