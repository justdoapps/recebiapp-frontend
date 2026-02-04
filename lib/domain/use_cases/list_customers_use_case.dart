import '../../core/utils/result.dart';
import '../../data/repositories/customer/customer_repository.dart';
import '../enum/customer_type_enum.dart';
import '../models/customer_model.dart';

class ListCustomersUseCase {
  final CustomerRepository _repository;

  ListCustomersUseCase({required CustomerRepository repository}) : _repository = repository;

  Future<Result<List<CustomerModel>>> getAll() async {
    final result = await _repository.getAll();
    return result.fold(
      (err) => Result.error(err),
      (value) {
        value.sort(
          (a, b) {
            if (a.active != b.active) {
              return a.active ? -1 : 1;
            }
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          },
        );
        return Result.ok(List.unmodifiable(value));
      },
    );
  }

  Future<Result<List<CustomerModel>>> getAllFromCache() async {
    return await _repository.getAll(fromCache: true);
  }

  Future<Result<List<CustomerModel>>> getFromCacheWithoutInactive({CustomerType? type}) async {
    final result = await _repository.getAll(fromCache: true);
    return result.fold(
      (err) => Result.error(err),
      (value) {
        final list = value
            .where((e) => e.active && (type != null ? e.type == type || e.type == CustomerType.BOTH : true))
            .toList();
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        return Result.ok(List.unmodifiable(list));
      },
    );
  }
}
