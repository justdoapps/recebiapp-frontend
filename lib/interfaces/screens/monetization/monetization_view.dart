import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_drawer.dart';
import 'monetization_view_model.dart';
import 'widgets/plan_card_widget.dart';

class MonetizationView extends StatefulWidget {
  const MonetizationView({super.key});

  @override
  State<MonetizationView> createState() => _MonetizationViewState();
}

class _MonetizationViewState extends State<MonetizationView> {
  late final MonetizationViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<MonetizationViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MonetizationViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monetização'),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => PlanCardWidget(plan: _vm.plans[index]),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: _vm.plans.length,
        ),
      ),
    );
  }
}
