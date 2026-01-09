import 'package:logging/logging.dart';

import '../../../core/mixins/http_request_mixin.dart';
import '../../../core/utils/result.dart';
import '../../../domain/models/plan_model.dart';
import '../../../interfaces/screens/monetization/monetization_view_model.dart';
import '../../services/http_service.dart';
import 'monetization_repository.dart';

class MonetizationRepositoryImpl with HttpRequestMixin implements MonetizationRepository {
  final HttpService _http;

  MonetizationRepositoryImpl({required HttpService http}) : _http = http;

  final _log = Logger('MonetizationRepositoryImpl');

  @override
  Future<Result<({List<PlanModel> plans, String? currentPlanId, String? currentPeriodEnd})>> getPlans() async {
    final result = await safeRequest(request: () => _http.get('/monetization/listplans'));

    return result.fold(
      (error) {
        _log.severe('Falha ao buscar planos', error);
        return Result.error(error);
      },
      (value) {
        return Result.ok(
          (
            plans: (value.data['plans'] as List).map((e) => PlanModel.fromMap(e)).toList(),
            currentPlanId: value.data['currentPlanId'],
            currentPeriodEnd: value.data['currentPeriodEnd'],
          ),
        );
      },
    );
  }

  @override
  Future<Result<MonetizationResultArgs>> createSubscription({required String planId}) async {
    final result = await safeRequest(request: () => _http.post('/monetization/subscription', data: {'planId': planId}));

    return result.fold(
      (error) {
        _log.severe('Falha ao criar assinatura', error);
        return Result.error(error);
      },
      (value) {
        if (value.statusCode != 201) {
          return Result.error(Exception(value.data['message']));
        }
        return Result.ok((
          paymentId: value.data['paymentId'],
          customerId: value.data['customerId'],
          clientSecret: value.data['clientSecret'],
          ephemeralKey: value.data['ephemeralKey'],
        ));
      },
    );
  }

  @override
  Future<Result<({String endsAt})>> cancelSubscription() async {
    final result = await safeRequest(request: () => _http.post('/monetization/cancel'));

    return result.fold(
      (error) {
        _log.severe('Falha ao cancelar assinatura', error);
        return Result.error(error);
      },
      (value) {
        return Result.ok((endsAt: value.data['endsAt']));
      },
    );
  }

  @override
  Future<Result<({String endsAt})>> uncancelSubscription() async {
    final result = await safeRequest(request: () => _http.post('/monetization/uncancel'));

    return result.fold(
      (error) {
        _log.severe('Falha ao reativar assinatura', error);
        return Result.error(error);
      },
      (value) {
        return Result.ok((endsAt: value.data['endsAt']));
      },
    );
  }

  @override
  Future<Result<MonetizationResultArgs>> createAnnualPlan({required String planId}) async {
    final result = await safeRequest(
      request: () => _http.post('/monetization/onetimeyearplan', data: {'planId': planId}),
    );

    return result.fold(
      (error) {
        _log.severe('Falha ao criar pagamento anual', error);
        return Result.error(error);
      },
      (value) {
        if (value.statusCode != 201) {
          return Result.error(Exception(value.data['message']));
        }
        return Result.ok((
          paymentId: value.data['paymentId'],
          customerId: value.data['customerId'],
          clientSecret: value.data['clientSecret'],
          ephemeralKey: value.data['ephemeralKey'],
        ));
      },
    );
  }

  @override
  Future<Result<({DateTime currentPeriodEnd, String currentPlanId})?>> getTenantMonetization() async {
    final result = await safeRequest(request: () => _http.get('/monetization/tenant'));

    return result.fold(
      (error) {
        _log.severe('Falha ao buscar monetização do tenant', error);
        return Result.error(error);
      },
      (value) {
        return Result.ok((
          currentPeriodEnd: value.data['currentPeriodEnd'],
          currentPlanId: value.data['currentPlanId'],
        ));
      },
    );
  }
}
