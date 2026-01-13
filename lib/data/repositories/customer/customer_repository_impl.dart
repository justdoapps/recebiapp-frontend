import 'package:logging/logging.dart';

import '../../../core/mixins/http_request_mixin.dart';
import '../../../core/utils/result.dart';
import '../../../domain/dtos/customer_upsert_dto.dart';
import '../../../domain/models/customer_model.dart';
import '../../services/http_service.dart';
import 'customer_repository.dart';

class CustomerRepositoryImpl with HttpRequestMixin implements CustomerRepository {
  final HttpService _http;

  CustomerRepositoryImpl({required HttpService http}) : _http = http;

  final _log = Logger('CustomerRepositoryImpl');

  List<CustomerModel> _cachedCustomers = [];
  List<CustomerModel> get cachedCustomers => List.unmodifiable(_cachedCustomers);
  bool _hasCache = false;

  @override
  Future<Result<void>> create({
    required CustomerCreateDto customer,
  }) async {
    final result = await safeRequest(
      request: () => _http.post('/customer', data: customer.toBodyRequest()),
    );

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 201 ? Result.okVoid() : Result.errorVoid(),
    );
  }

  @override
  Future<Result<void>> toggleStatus({
    required String id,
    required bool active,
  }) async {
    final result = await safeRequest(
      request: () => _http.patch('/customer/$id', data: {'active': active}),
    );

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 204 ? Result.okVoid() : Result.errorVoid(),
    );
  }

  @override
  Future<Result<List<CustomerModel>>> getAll({bool fromCache = false}) async {
    if (fromCache && _hasCache) return Result.ok(cachedCustomers);

    final result = await safeRequest(request: () => _http.get('/customer'));

    return result.fold((error) => Result.error(error), (value) {
      _cachedCustomers = (value.data as List).map((e) => CustomerModel.fromMap(e)).toList();
      _hasCache = true;
      return Result.ok(cachedCustomers);
    });
  }

  // @override
  // Future<Result<CustomerModel>> getById({required String id}) async {
  //   final result = await safeRequest(request: () => _http.get('/customer/$id'));

  //   return result.fold((error) => Result.error(error), (value) {
  //     return Result.ok(CustomerModel.fromMap(value.data));
  //   });
  // }

  @override
  Future<Result<void>> update({required CustomerUpdateDto customer}) async {
    final result = await safeRequest(
      request: () => _http.patch('/customer/${customer.id}', data: customer.toBodyRequest()),
    );

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 204 ? Result.okVoid() : Result.errorVoid(),
    );
  }
}
