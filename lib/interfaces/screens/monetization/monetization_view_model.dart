import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/monetization/monetization_repository.dart';
import '../../../domain/enum/monetization_enum.dart';
import '../../../domain/models/plan_model.dart';

typedef MonetizationResultArgs = ({String paymentId, String customerId, String clientSecret, String ephemeralKey});

class MonetizationViewModel extends ChangeNotifier {
  final MonetizationRepository _repository;
  final AuthRepository _repAuth;

  MonetizationViewModel({required MonetizationRepository repository, required AuthRepository repAuth})
    : _repository = repository,
      _repAuth = repAuth {
    createSubscription = Command1<MonetizationResultArgs, String>(_createSubscription);
    createAnnualPlan = Command1<MonetizationResultArgs, String>(_createAnnualPlan);
    getPlans = Command0<void>(_getPlans);
    cancelSubscription = Command0<({String endsAt})>(_cancelSubscription);
    uncancelSubscription = Command0<({String endsAt})>(_uncancelSubscription);
  }

  final _log = Logger('MonetizationViewModel');
  List<PlanModel> plans = [];
  String? currentPlanId;
  DateTime? currentPeriodEnd;

  late Command1<MonetizationResultArgs, String> createSubscription;
  late Command1<MonetizationResultArgs, String> createAnnualPlan;
  late Command0<void> getPlans; //já vem com o plano vigente do tenant caso tiver
  late Command0<({String endsAt})> cancelSubscription;
  late Command0<({String endsAt})> uncancelSubscription;

  Future<Result<MonetizationResultArgs>> _createSubscription(String planId) async =>
      (await _repository.createSubscription(planId: planId)).fold(
        (error) {
          _log.warning('Create Subscription falhou: $error');
          return Result.error(error);
        },
        (value) {
          return Result.ok(value);
        },
      );

  Future<Result<MonetizationResultArgs>> _createAnnualPlan(String planId) async =>
      (await _repository.createAnnualPlan(planId: planId)).fold(
        (error) {
          _log.warning('Create Annual Plan falhou: $error');
          return Result.error(error);
        },
        (value) {
          return Result.ok(value);
        },
      );

  Future<Result<({String endsAt})>> _cancelSubscription() async => (await _repository.cancelSubscription()).fold(
    (error) {
      _log.warning('Cancel Subscription falhou: $error');
      return Result.error(error);
    },
    (value) {
      return Result.ok(value);
    },
  );

  Future<Result<({String endsAt})>> _uncancelSubscription() async => (await _repository.uncancelSubscription()).fold(
    (error) {
      _log.warning('Uncancel Subscription falhou: $error');
      return Result.error(error);
    },
    (value) {
      return Result.ok(value);
    },
  );

  Future<Result<void>> _getPlans() async => (await _repository.getPlans()).fold(
    (error) {
      _log.warning('Get Plans falhou: $error');
      return Result.error(error);
    },
    (value) {
      plans = value.plans;
      currentPlanId = value.currentPlanId;
      if (value.currentPeriodEnd != null) {
        currentPeriodEnd = DateTime.parse(value.currentPeriodEnd!);
      }
      notifyListeners();
      return const Result.ok(null);
    },
  );

  void updatePremium({required MonetizationPlan plan, required DateTime currentPeriodEnd}) {
    _repAuth.updatePremium(plan: plan, currentPeriodEnd: currentPeriodEnd);
  }

  @override
  void dispose() {
    createSubscription.dispose();
    createAnnualPlan.dispose();
    getPlans.dispose();
    cancelSubscription.dispose();
    uncancelSubscription.dispose();
    super.dispose();
  }
}
