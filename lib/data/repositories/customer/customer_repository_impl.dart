import 'package:logging/logging.dart';

import '../../../core/mixins/http_request_mixin.dart';
import '../../../core/utils/result.dart';
import '../../../domain/dtos/customer_upsert_dto.dart';
import '../../../domain/models/customer_model.dart';
import '../../services/http_service.dart';
import 'customer_repository.dart';

class CustomerRepositoryImpl
    with HttpRequestMixin
    implements CustomerRepository {
  final HttpService _http;

  CustomerRepositoryImpl({required HttpService http}) : _http = http;

  final _log = Logger('CustomerRepositoryImpl');

  @override
  Future<Result<CustomerModel>> create({
    required CustomerCreateDto customer,
  }) async {
    final result = await safeRequest(
      request: () => _http.post('/customer', data: customer.toMap()),
    );

    return result.fold((error) => Result.error(error), (value) {
      return Result.ok(CustomerModel.fromMap(value.data));
    });
  }

  @override
  Future<Result<CustomerModel>> toggleStatus({
    required String id,
    required bool active,
  }) async {
    final result = await safeRequest(
      request: () => _http.put('/customer/$id', data: {'active': active}),
    );

    return result.fold((error) => Result.error(error), (value) {
      return Result.ok(CustomerModel.fromMap(value.data));
    });
  }

  @override
  Future<Result<List<CustomerModel>>> getAll() async {
    final result = await safeRequest(request: () => _http.get('/customer'));

    return result.fold((error) => Result.error(error), (value) {
      return Result.ok(
        value.data.map((e) => CustomerModel.fromMap(e)).toList(),
      );
    });
  }

  @override
  Future<Result<CustomerModel>> getById({required String id}) async {
    final result = await safeRequest(request: () => _http.get('/customer/$id'));

    return result.fold((error) => Result.error(error), (value) {
      return Result.ok(CustomerModel.fromMap(value.data));
    });
  }

  @override
  Future<Result<CustomerModel>> update({
    required CustomerUpdateDto customer,
    required String id,
  }) async {
    final result = await safeRequest(
      request: () => _http.patch('/customer/$id', data: customer.toMap()),
    );

    return result.fold((error) => Result.error(error), (value) {
      return Result.ok(CustomerModel.fromMap(value.data));
    });
  }
}
