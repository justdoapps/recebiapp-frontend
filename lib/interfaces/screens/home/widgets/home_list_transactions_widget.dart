import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../domain/models/transaction_model.dart';
import '../lang/home_localization_ext.dart';
import 'home_transaction_card_widget.dart';

class HomeListTransactionsWidget extends StatelessWidget {
  const HomeListTransactionsWidget({super.key, required this.transactions});

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: transactions.isEmpty
          ? [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(context.words.noTransactionsFound, style: context.textTheme.large),
                ),
              ),
            ]
          : [
              SliverList.separated(
                itemBuilder: (context, index) {
                  return HomeTransactionCardWidget(transaction: transactions[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: transactions.length,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
    );
  }
}
