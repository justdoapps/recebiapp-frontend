import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../domain/models/plan_model.dart';
import '../../../core/app_gradient_button.dart';
import '../lang/monetization_localization_ext.dart';

class PlanCardWidget extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;

  const PlanCardWidget({
    super.key,
    required this.plan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onSurface,
        borderRadius: .circular(20),
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.7),
            blurRadius: 12,
            offset: const Offset(1, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const .all(24.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  plan.name,
                  style: context.textTheme.mediumBold.copyWith(color: context.theme.colorScheme.surface),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: plan.amountCents.toCurrency(context.locale),
                    style: context.textTheme.largeBold.copyWith(color: context.theme.colorScheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              plan.description,
              style: context.textTheme.smallBold.copyWith(color: context.theme.colorScheme.surface),
            ),
            const SizedBox(height: 16),
            AppGradientButton(onPressed: onTap, label: context.words.buy),
          ],
        ),
      ),
    );
  }
}
