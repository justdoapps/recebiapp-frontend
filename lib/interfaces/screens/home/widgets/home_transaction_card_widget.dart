import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/dialog_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../core/extensions/message_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../domain/enum/transaction_enum.dart';
import '../../../../domain/models/transaction_model.dart';
import '../../../core/adaptive_date_picker.dart';
import '../../../core/app_gradient_button.dart';
import '../components/upsert_transaction_component.dart';
import '../home_view_model.dart';
import '../lang/home_localization_ext.dart';

class HomeTransactionCardWidget extends StatelessWidget {
  const HomeTransactionCardWidget({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final colorType = transaction.type == TransactionType.INCOME ? Colors.green : Colors.orange;
    final colorStatus = transaction.status.getStatusColor();
    final vm = context.read<HomeViewModel>();

    return Card(
      color: context.theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(18)),
      child: InkWell(
        borderRadius: .circular(18),
        onLongPress: () {
          vm.toggleSelection(transaction);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: .circular(18),
            border: Border(
              left: BorderSide(color: colorType, width: 5),
              bottom: BorderSide(color: colorType, width: 2),
            ),
          ),
          padding: const .all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Flexible(
                    fit: .tight,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(transaction.customer.name, style: context.textTheme.mediumBold),
                        if (transaction.description.isNotEmpty)
                          Text(
                            transaction.description,
                            style: context.textTheme.small,
                            softWrap: true,
                          ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${transaction.type == TransactionType.INCOME ? "+" : "-"} ${transaction.amount.toCurrency(context.locale)}',
                      style: context.textTheme.mediumBold.copyWith(color: colorType),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Visibility(
                      visible: vm.isSelectionMode,
                      child: Checkbox.adaptive(
                        visualDensity: VisualDensity.compact,
                        value: vm.isSelected(transaction),
                        onChanged: (_) => vm.toggleSelection(transaction),
                      ),
                    ),
                    Flexible(
                      fit: .tight,
                      child: Divider(thickness: 2, color: colorStatus),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      transaction.status.getStatusName(context),
                      style: context.textTheme.small.copyWith(color: colorStatus),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        transaction.dueDate.toLocaleDayDateWithoutYear(context.locale),
                        style: context.textTheme.smallBold,
                      ),
                      if (transaction.paidAt != null && transaction.status == TransactionStatus.PAID)
                        Text(
                          transaction.paidAt!.toLocaleDayDateWithoutYear(context.locale),
                          style: context.textTheme.smallBold.copyWith(color: colorStatus),
                        ),
                    ],
                  ),

                  const Spacer(),

                  Visibility(
                    visible: !vm.isSelectionMode,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.push('${Routes.home}${Routes.transactionDetails}', extra: transaction);
                          },
                          icon: Icon(
                            Icons.open_in_new,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                        Visibility(
                          visible:
                              transaction.status != TransactionStatus.PAID &&
                              transaction.status != TransactionStatus.CANCELED &&
                              transaction.customer.phone != null,
                          child: IconButton(
                            onPressed: () async {
                              //TODO escolher a menssagem padrão
                              final phoneNumber = transaction.customer.phone!;
                              final encodedMessage = Uri.encodeComponent('');
                              final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');
                              try {
                                if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalNonBrowserApplication)) {
                                  throw Exception('Não foi possível abrir o WhatsApp.');
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  context.showMessage(message: 'Não foi possível abrir o WhatsApp.');
                                }
                              }
                            },
                            icon: const FaIcon(FontAwesomeIcons.whatsapp),
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                        transaction.status != TransactionStatus.PAID
                            ? PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: context.theme.colorScheme.primary,
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () {
                                      context.showBottomSheet(
                                        child: Padding(
                                          padding: .only(bottom: context.viewInsetsBottom),
                                          child: ChangeNotifierProvider.value(
                                            value: vm,
                                            child: UpsertTransactionComponent(transaction: transaction),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(context.words.edit),
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                      transaction.status == TransactionStatus.CANCELED
                                          ? context.words.uncancel
                                          : context.words.cancel,
                                    ),
                                    onTap: () {
                                      final UpdateStatusArgs args = (
                                        paymentDate: null,
                                        status: transaction.status == TransactionStatus.CANCELED
                                            ? TransactionStatus.PENDING
                                            : TransactionStatus.CANCELED,
                                        transaction: transaction,
                                      );
                                      vm.updateStatus.execute(args);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text(context.words.delete),
                                    onTap: () {
                                      context.showConfirmationDialog(
                                        title: Text(context.words.confirmDelete, style: context.textTheme.medium),
                                        content: Text(
                                          context.words.confirmDeleteWarning,
                                          style: context.textTheme.small,
                                        ),
                                        onConfirm: () {
                                          vm.deleteTransaction.execute(transaction);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              )
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const .symmetric(horizontal: 8),
                                  side: BorderSide(width: 2, color: context.theme.colorScheme.primary),
                                ),
                                onPressed: () {
                                  context.showConfirmationDialog(
                                    content: Text(context.words.confirmCancelPayment, style: context.textTheme.small),
                                    onConfirm: () {
                                      final UpdateStatusArgs args = (
                                        paymentDate: null,
                                        status: TransactionStatus.PENDING,
                                        transaction: transaction,
                                      );
                                      vm.updateStatus.execute(args);
                                    },
                                  );
                                },
                                child: Text(context.words.cancelPayment),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              if (transaction.status != TransactionStatus.PAID &&
                  transaction.status != TransactionStatus.CANCELED &&
                  !vm.isSelectionMode)
                AppGradientButton(
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
                        final UpdateStatusArgs args = (
                          paymentDate: paymentDate,
                          status: TransactionStatus.PAID,
                          transaction: transaction,
                        );
                        vm.updateStatus.execute(args);
                      },
                    );
                  },
                  label: context.words.pay,
                  height: 30,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
