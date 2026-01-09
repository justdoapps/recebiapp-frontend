import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/dialog_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../domain/enum/monetization_enum.dart';
import '../../../../domain/models/plan_model.dart';
import '../lang/monetization_localization_ext.dart';
import '../monetization_view_model.dart';
import 'plan_card_widget.dart';

class CurrentPlanWidget extends StatelessWidget {
  const CurrentPlanWidget({super.key, required this.plan});

  final PlanModel plan;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MonetizationViewModel>();
    if (vm.currentPeriodEnd != null) {
      vm.updatePremium(
        plan: plan.interval == 'one_time' ? MonetizationPlan.PREMIUM_MANUAL : MonetizationPlan.PREMIUM_MENSAL,
        currentPeriodEnd: vm.currentPeriodEnd!,
      );
    }
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          context.words.validUntil,
          style: context.textTheme.large,
        ),
        Text(
          vm.currentPeriodEnd?.toLocaleDayDate(context.locale) ?? '',
          style: context.textTheme.largeBold,
        ),
        const SizedBox(height: 16),
        PlanCardWidget(
          plan: plan,
          hasPlanActivated: true,
          onTap: () async {
            if (plan.interval == 'one_time') {
              final confirmed = await context.showConfirmationDialog(content: Text(context.words.buyAgainConfirm));
              if (confirmed ?? false) vm.createAnnualPlan.execute(plan.id);
            } else {
              final confirmed = await context.showConfirmationDialog(content: Text(context.words.cancelSubscription));
              if (confirmed ?? false) vm.cancelSubscription.execute();
            }
          },
        ),
      ],
    );
  }
}
