import '../../../core/mixins/http_request_mixin.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../../domain/dtos/recurrence_upsert_dto.dart';
import '../../../domain/models/recurrence_model.dart';
import '../../services/http_service.dart';
import 'recurrence_repository.dart';

class RecurrenceRepositoryImpl with HttpRequestMixin implements RecurrenceRepository {
  final HttpService _http;

  RecurrenceRepositoryImpl({required HttpService http}) : _http = http;

  List<RecurrenceModel> _listCached = [];
  List<RecurrenceModel> get listCached => List.from(_listCached);
  bool _hasCache = false;

  @override
  Future<Result<void>> create(RecurrenceCreateDto recurrence) async {
    final result = await safeRequest(request: () => _http.post('/recurrence', data: recurrence.toMap()));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 201 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<void>> delete(String id) async {
    final result = await safeRequest(request: () => _http.delete('/recurrence/$id'));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 204 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<List<RecurrenceModel>>> list({bool fromCache = false}) async {
    if (fromCache && _hasCache) return Result.ok(listCached);

    final result = await safeRequest(request: () => _http.get('/recurrence'));

    return result.fold(
      (error) => Result.error(error),
      (value) {
        if (value.statusCode != 200) return Result.error(StatusCodeFailure());
        _listCached = (value.data as List).map((e) => RecurrenceModel.fromMap(e)).toList();
        _hasCache = true;
        return Result.ok(listCached);
      },
    );
  }

  @override
  Future<Result<void>> update(RecurrenceUpdateDto recurrence) async {
    final result = await safeRequest(
      request: () => _http.patch('/recurrence/${recurrence.id}', data: recurrence.toMap()),
    );

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 200 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }
}
