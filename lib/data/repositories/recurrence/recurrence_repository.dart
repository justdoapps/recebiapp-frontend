import '../../../core/utils/result.dart';
import '../../../domain/dtos/recurrence_upsert_dto.dart';
import '../../../domain/models/recurrence_model.dart';

abstract class RecurrenceRepository {
  Future<Result<void>> create(RecurrenceCreateDto recurrence);
  Future<Result<void>> update(RecurrenceUpdateDto recurrence);
  Future<Result<void>> delete(String id);
  Future<Result<List<RecurrenceModel>>> list({bool fromCache = false});
}
