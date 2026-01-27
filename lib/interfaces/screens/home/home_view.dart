import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/dialog_extension.dart';
import '../../../core/extensions/message_extension.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/utils/throttler.dart';
import '../../../domain/enum/transaction_enum.dart';
import '../../../domain/models/transaction_model.dart';
import '../../core/adaptive_date_picker.dart';
import '../../core/app_drawer.dart';
import 'components/upsert_transaction_component.dart';
import 'home_view_model.dart';
import 'lang/home_localization_ext.dart';
import 'widgets/home_list_transactions_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with LoadingMixin {
  late final HomeViewModel _vm;
  final TextEditingController _searchEC = TextEditingController();
  final Debouncer _searchDebouncer = Debouncer(const Duration(milliseconds: 300));
  final Throttler _clearThrottler = Throttler(const Duration(milliseconds: 500));

  @override
  void initState() {
    _vm = context.read<HomeViewModel>();
    _vm.listTransactions.addListener(_listenerCommandList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.listTransactions.execute();
    });
    super.initState();
  }

  @override
  void dispose() {
    _vm.listTransactions.removeListener(_listenerCommandList);
    _searchEC.dispose();
    _searchDebouncer.cancel();
    _clearThrottler.cancel();
    super.dispose();
  }

  void _listenerCommandList() {
    _vm.listTransactions.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.listTransactions.error) {
      context.showMessage(
        title: context.words.errorGetTransactions,
        actionLabel: context.words.tryAgain,
        onAction: () {
          _vm.listTransactions.clearResult();
          _vm.listTransactions.execute();
        },
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<HomeViewModel, bool>(
      selector: (_, _) => _vm.isSelectionMode,
      builder: (_, isSelectionMode, _) {
        return isSelectionMode
            ? Scaffold(
                persistentFooterDecoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.theme.colorScheme.onSurface.withValues(alpha: .5),
                    ),
                  ),
                ),
                persistentFooterButtons: [
                  Row(
                    mainAxisAlignment: .spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          _vm.clearSelection();
                        },
                        child: Text(
                          context.words.back,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.showConfirmationDialog(
                            content: Text(
                              context.words.confirmCancelAll(_vm.selectedTransactions.length),
                              style: context.textTheme.medium,
                            ),
                            onConfirm: () {
                              final BatchUpdateStatusArgs args = (
                                paymentDate: null,
                                status: TransactionStatus.CANCELED,
                                transactions: _vm.selectedTransactions,
                              );
                              _vm.batchUpdateStatus.execute(args);
                            },
                          );
                        },
                        child: Text(context.words.cancelAll),
                      ),
                      TextButton(
                        onPressed: () async {
                          DateTime? paymentDate;
                          await context.showConfirmationDialog(
                            title: Text(context.words.selectDatePayment, style: context.textTheme.medium),
                            content: Column(
                              mainAxisSize: .min,
                              children: [
                                SizedBox(
                                  width: .maxFinite,
                                  child: AdaptiveDatePicker(
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                                    onDateChanged: (value) {
                                      paymentDate = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            onConfirm: () {
                              final BatchUpdateStatusArgs args = (
                                paymentDate: paymentDate,
                                status: TransactionStatus.PAID,
                                transactions: _vm.selectedTransactions,
                              );
                              _vm.batchUpdateStatus.execute(args);
                            },
                          );
                        },
                        child: Text(context.words.payAll),
                      ),
                    ],
                  ),
                ],
                body: SafeArea(
                  child: Selector<HomeViewModel, List<TransactionModel>>(
                    selector: (_, _) => _vm.selectedTransactions,
                    builder: (_, _, _) {
                      return HomeListTransactionsWidget(transactions: _vm.filteredTransactions);
                    },
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text(context.words.home),
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
                          child: const UpsertTransactionComponent(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(context.words.newData),
                ),
                body: RefreshIndicator(
                  onRefresh: _vm.listTransactions.execute,
                  child: Selector<HomeViewModel, List<TransactionModel>>(
                    selector: (_, _) => _vm.filteredTransactions,
                    builder: (_, filteredTransactions, _) {
                      return Column(
                        children: [
                          Expanded(child: HomeListTransactionsWidget(transactions: filteredTransactions)),
                        ],
                      );
                    },
                  ),
                ),
              );
      },
    );
  }
}
