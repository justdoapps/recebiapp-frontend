import '../../../core/utils/result.dart';
import '../../../domain/dtos/template_upsert_dto.dart';
import '../../../domain/models/template_model.dart';

abstract class TemplateRepository {
  Future<Result<void>> create(TemplateCreateDto template);
  Future<Result<void>> update(TemplateUpdateDto template);
  Future<Result<void>> delete(String id);
  Future<Result<List<TemplateModel>>> list({bool fromCache = false});
}
