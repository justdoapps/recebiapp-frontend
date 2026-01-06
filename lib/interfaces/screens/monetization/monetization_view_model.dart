import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/monetization/monetization_repository.dart';
import '../../../domain/models/plan_model.dart';

typedef MonetizationResultArgs = ({String id, String clientSecret, String ephemeralKey});

class MonetizationViewModel extends ChangeNotifier {
  final MonetizationRepository _repository;

  MonetizationViewModel({required MonetizationRepository repository}) : _repository = repository {
    createSubscription = Command1<void, String>(_createSubscription);
    createAnnualPlan = Command1<void, String>(_createAnnualPlan);
    getPlans = Command0<void>(_getPlans);
    cancelSubscription = Command0<void>(_cancelSubscription);
    uncancelSubscription = Command0<void>(_uncancelSubscription);
    getPlans.execute();
  }

  final _log = Logger('MonetizationViewModel');
  List<PlanModel> plans = [];
  String? currentPlan;

  late Command1<void, String> createSubscription;
  late Command1<void, String> createAnnualPlan;
  late Command0<void> getPlans; //já vem com o plano vigente do tenant caso tiver
  late Command0<void> cancelSubscription;
  late Command0<void> uncancelSubscription;

  Future<Result<MonetizationResultArgs>> _createSubscription(String planId) async {
    final result = await _repository.createSubscription(planId: planId);
    return result.fold(
      (error) {
        _log.warning('Create Subscription falhou: $error');
        return Result.error(error);
      },
      (value) {
        return Result.ok(value);
      },
    );
  }

  Future<Result<MonetizationResultArgs>> _createAnnualPlan(String planId) async {
    final result = await _repository.createAnnualPlan(planId: planId);
    return result.fold(
      (error) {
        _log.warning('Create Annual Plan falhou: $error');
        return Result.error(error);
      },
      (value) {
        return Result.ok(value);
      },
    );
  }

  Future<Result<({String endsAt})>> _cancelSubscription() async {
    final result = await _repository.cancelSubscription();
    return result.fold(
      (error) {
        _log.warning('Cancel Subscription falhou: $error');
        return Result.error(error);
      },
      (value) {
        return Result.ok(value);
      },
    );
  }

  Future<Result<({String endsAt})>> _uncancelSubscription() async {
    final result = await _repository.uncancelSubscription();
    return result.fold(
      (error) {
        _log.warning('Uncancel Subscription falhou: $error');
        return Result.error(error);
      },
      (value) {
        return Result.ok(value);
      },
    );
  }

  Future<Result<void>> _getPlans() async {
    final result = await _repository.getPlans();
    return result.fold(
      (error) {
        _log.warning('Get Plans falhou: $error');
        return Result.error(error);
      },
      (value) {
        plans = value.plans;
        currentPlan = value.currentPlan;
        notifyListeners();
        return const Result.ok(null);
      },
    );
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
