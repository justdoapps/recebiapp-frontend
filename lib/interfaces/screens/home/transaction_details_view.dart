import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/formatters_extension.dart';
import '../../../core/extensions/message_extension.dart';
import '../../../domain/enum/transaction_enum.dart';
import '../../../domain/models/transaction_model.dart';
import '../../core/loader_local.dart';
import '../customer/lang/customer_localization_ext.dart';
import 'lang/home_localization_ext.dart';
import 'transaction_details_view_model.dart';

class TransactionDetailsView extends StatelessWidget {
  const TransactionDetailsView({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final colorStatus = transaction.status.getStatusColor();
    final isIncome = transaction.type == TransactionType.INCOME;
    final colorType = isIncome ? Colors.green : Colors.orange;
    final vm = context.read<TransactionDetailsViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(context.words.transactionDetails)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const .all(8),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Center(
                child: Text(
                  transaction.amount.toCurrency(context.locale),
                  style: context.textTheme.veryLargeBold.copyWith(color: colorType),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const .symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorStatus.withValues(alpha: .15),
                    borderRadius: .circular(30),
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorStatus,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        transaction.status.getStatusName(context).toUpperCase(),
                        style: context.textTheme.smallBold.copyWith(
                          color: colorStatus,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionHeader(context, context.words.basicInfo),
              Card(
                color: context.colors.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(context, context.words.description),
                      Text(transaction.description, style: context.textTheme.mediumBold),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(context, context.words.type),
                                Row(
                                  children: [
                                    FaIcon(
                                      isIncome ? FontAwesomeIcons.anglesUp : FontAwesomeIcons.anglesDown,
                                      color: colorType,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      transaction.type.getTypeName(context).toUpperCase(),
                                      style: context.textTheme.smallBold.copyWith(color: colorType),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(context, context.words.createdAt),
                                Text(
                                  transaction.createdAt.toLocaleDayDate(context.locale),
                                  style: context.textTheme.smallBold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              _buildSectionHeader(context, context.words.attachments),
              ListenableBuilder(
                listenable: vm.downloadAttachment,
                builder: (context, child) {
                  return LoaderLocal(
                    isLoading: vm.downloadAttachment.running,
                    child: Card(
                      color: context.colors.surfaceContainer,
                      child: transaction.attachmentId != null
                          ? ListTile(
                              // leading: IconButton.filledTonal(
                              //   onPressed: () {
                              //     vm.deleteAttachment.execute(transaction);
                              //   },
                              //   icon: const Icon(Icons.clear),
                              // ),
                              title: Text(
                                transaction.attachmentName ?? context.words.noName,
                                style: context.textTheme.verySmallBold,
                              ),
                              subtitle: Text(
                                transaction.attachmentSize?.bytesToMbString() ?? context.words.noSize,
                                style: context.textTheme.verySmallBold,
                              ),
                              trailing: IconButton.filledTonal(
                                onPressed: () {
                                  vm.downloadAttachment.execute(transaction);
                                },
                                icon: const Icon(Icons.download),
                              ),
                            )
                          : ListTile(title: Text(context.words.noAttachment, style: context.textTheme.smallBold)),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
              _buildSectionHeader(context, context.words.customerDetails),
              Card(
                color: context.colors.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.customer.name,
                                  style: context.textTheme.mediumBold,
                                ),
                                if (transaction.customer.observation != null)
                                  Text(
                                    transaction.customer.observation!,
                                    style: context.textTheme.small,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (transaction.customer.phone != null) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 18, color: context.colors.onSurface),
                            const SizedBox(width: 8),
                            Text(
                              transaction.customer.phone!,
                              style: context.textTheme.small,
                            ),
                            const Spacer(),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final phoneNumber = transaction.customer.phone!;
                                final encodedMessage = Uri.encodeComponent('');
                                final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');
                                try {
                                  if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalNonBrowserApplication)) {
                                    throw Exception('Não foi possível abrir o WhatsApp.');
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    context.showMessage(message: context.words.couldNotOpenWhatsApp);
                                  }
                                }
                              },
                              icon: const FaIcon(FontAwesomeIcons.whatsapp),
                              label: Text(context.words.message),
                              iconAlignment: .end,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: context.colors.primary, width: 2),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (transaction.customer.document != null)
                        Row(
                          children: [
                            Icon(Icons.badge, size: 18, color: context.colors.onSurface),
                            const SizedBox(width: 8),
                            Text(
                              transaction.customer.document!,
                              style: context.textTheme.small,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionHeader(context, context.words.dates),
              Card(
                color: context.colors.surfaceContainer,
                child: Padding(
                  padding: const .all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const .all(8),
                            decoration: BoxDecoration(
                              color: context.colors.primary.withValues(alpha: 0.1),
                              borderRadius: .circular(8),
                            ),
                            child: Icon(Icons.calendar_month, color: context.colors.primary, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Text(context.words.dueDate, style: context.textTheme.small),
                          const Spacer(),
                          Text(
                            transaction.dueDate.toLocaleDayDate(context.locale),
                            style: context.textTheme.smallBold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const .all(8),
                            decoration: BoxDecoration(
                              color: context.colors.primary.withValues(alpha: 0.1),
                              borderRadius: .circular(8),
                            ),
                            child: Icon(Icons.check_circle, color: context.colors.primary, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Text(context.words.paidAt, style: context.textTheme.small),
                          const Spacer(),
                          Text(
                            transaction.paidAt?.toLocaleDayDate(context.locale) ?? context.words.notPaidYet,
                            style: transaction.paidAt != null
                                ? context.textTheme.smallBold
                                : context.textTheme.small.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade400,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionHeader(context, context.words.notes),
              Card(
                color: context.colors.surfaceContainer,
                child: Padding(
                  padding: const .all(16.0),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      _buildLabel(context, context.words.internalNote),
                      const SizedBox(height: 4),
                      Text(
                        transaction.internalNote ?? context.words.noNotesProvided,
                        style: context.textTheme.medium.copyWith(
                          color: transaction.internalNote == null ? Colors.grey : null,
                          fontStyle: transaction.internalNote == null ? FontStyle.italic : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel(context, context.words.customerNote),
                      const SizedBox(height: 4),
                      Text(
                        transaction.customerNote ?? context.words.noNotesProvided,
                        style: context.textTheme.medium.copyWith(
                          color: transaction.customerNote == null ? Colors.grey : null,
                          fontStyle: transaction.customerNote == null ? FontStyle.italic : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              _buildSectionHeader(context, context.words.paymentInfo),
              Card(
                color: context.colors.surfaceContainer,
                child: Padding(
                  padding: const .all(16.0),
                  child: Text(
                    transaction.paymentInfo ?? context.words.noPaymentInfoProvided,
                    style: context.textTheme.medium.copyWith(
                      color: transaction.internalNote == null ? Colors.grey : null,
                      fontStyle: transaction.internalNote == null ? FontStyle.italic : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, left: 10),
      child: Text(
        title,
        style: context.textTheme.smallBold.copyWith(
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Padding(
      padding: const .only(bottom: 2),
      child: Text(
        label,
        style: context.textTheme.verySmallBold.copyWith(
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
