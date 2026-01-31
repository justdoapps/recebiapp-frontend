import '../../core/utils/result.dart';
import '../../data/repositories/recurrence_template/template_repository.dart';
import '../models/template_model.dart';

class TemplateListUseCase {
  final TemplateRepository _repository;

  TemplateListUseCase({required TemplateRepository repository}) : _repository = repository;

  Future<Result<List<TemplateModel>>> list() async {
    return await _repository.list();
  }

  Future<Result<List<TemplateModel>>> listFromCache() async {
    return await _repository.list(fromCache: true);
  }

  Future<Result<List<TemplateModel>>> listFromCacheWithoutInactive() async {
    final result = await _repository.list(fromCache: true);
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
