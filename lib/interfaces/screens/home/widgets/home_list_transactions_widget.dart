import 'package:flutter/material.dart';

import '../../../../domain/models/transaction_model.dart';

class HomeListTransactionsWidget extends StatelessWidget {
  const HomeListTransactionsWidget({super.key, required this.transactions});

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
