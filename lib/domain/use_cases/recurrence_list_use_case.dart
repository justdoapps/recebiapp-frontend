import '../../core/utils/result.dart';
import '../../data/repositories/recurrence/recurrence_repository.dart';
import '../models/recurrence_model.dart';

class RecurrenceListUseCase {
  final RecurrenceRepository _repository;

  RecurrenceListUseCase({required RecurrenceRepository repository}) : _repository = repository;

  Future<Result<List<RecurrenceModel>>> list() async {
    return await _repository.list();
  }

  Future<Result<List<RecurrenceModel>>> listFromCache() async {
    return await _repository.list(fromCache: true);
  }

  Future<Result<List<RecurrenceModel>>> listFromCacheWithoutInactive() async {
    final result = await _repository.list(fromCache: true);
    return result.fold(
      (err) => Result.error(err),
      (value) {
        final list = value.where((e) => e.isActive).toList();
        list.sort((a, b) => a.description.compareTo(b.description));
        return Result.ok(list);
      },
    );
  }
}
