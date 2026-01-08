// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extension.dart';

enum MonetizationPlan {
  FREE,
  FREE_TRIAL,
  PREMIUM_MENSAL,
  PREMIUM_MANUAL
  ;

  factory MonetizationPlan.fromString(String? value) {
    if (value == null) return MonetizationPlan.FREE;

    return MonetizationPlan.values.firstWhere(
      (e) => e.name == value,
      orElse: () {
        return MonetizationPlan.FREE;
      },
    );
  }

  String getPlanName(BuildContext context) {
    switch (this) {
      case MonetizationPlan.FREE:
        return context.words.free;
      case MonetizationPlan.FREE_TRIAL:
        return context.words.freeTrial;
      case MonetizationPlan.PREMIUM_MENSAL:
        return context.words.premiumMensal;
      case MonetizationPlan.PREMIUM_MANUAL:
        return context.words.premiumManual;
    }
  }
}
