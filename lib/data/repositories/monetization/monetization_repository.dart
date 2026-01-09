import '../../../core/utils/result.dart';
import '../../../domain/models/plan_model.dart';
import '../../../interfaces/screens/monetization/monetization_view_model.dart';

abstract class MonetizationRepository {
  Future<Result<({List<PlanModel> plans, String? currentPlanId, String? currentPeriodEnd})>> getPlans();
  Future<Result<({String currentPlanId, DateTime currentPeriodEnd})?>> getTenantMonetization();
  Future<Result<MonetizationResultArgs>> createSubscription({required String planId});
  Future<Result<({String endsAt})>> cancelSubscription();
  Future<Result<({String endsAt})>> uncancelSubscription();
  Future<Result<MonetizationResultArgs>> createAnnualPlan({required String planId});
}
