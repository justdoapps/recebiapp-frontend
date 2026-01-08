import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../domain/models/plan_model.dart';

class CurrentPlanWidget extends StatelessWidget {
  const CurrentPlanWidget({super.key, required this.plan});

  final PlanModel plan;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(plan.name),
          Text(plan.amountCents.toCurrency(context.locale)),
          Text(plan.interval),
        ],
      ),
    );
  }
}
