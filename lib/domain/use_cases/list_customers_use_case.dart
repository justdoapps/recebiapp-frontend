import '../../core/utils/result.dart';
import '../../data/repositories/customer/customer_repository.dart';
import '../models/customer_model.dart';

class ListCustomersUseCase {
  final CustomerRepository _repository;

  ListCustomersUseCase({required CustomerRepository repository}) : _repository = repository;

  Future<Result<List<CustomerModel>>> getAll() async {
    return await _repository.getAll();
  }

  Future<Result<List<CustomerModel>>> getAllFromCache() async {
    return await _repository.getAll(fromCache: true);
  }

  Future<Result<List<CustomerModel>>> getFromCacheWithoutInactive() async {
    final result = await _repository.getAll(fromCache: true);
    return result.fold(
      (err) => Result.error(err),
      (value) {
        final list = value.where((e) => e.active).toList();
        list.sort((a, b) => a.name.compareTo(b.name));
        return Result.ok(list);
      },
    );
  }
}
