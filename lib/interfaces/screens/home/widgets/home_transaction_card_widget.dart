import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../domain/models/transaction_model.dart';

class HomeTransactionCardWidget extends StatelessWidget {
  const HomeTransactionCardWidget({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(12),
        side: BorderSide(color: context.theme.colorScheme.outline, width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(transaction.description, style: context.textTheme.large),
                Text(transaction.amount.toCurrency(context.locale)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
