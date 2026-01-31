import 'package:logging/logging.dart';

import '../../../core/mixins/http_request_mixin.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../../domain/dtos/template_upsert_dto.dart';
import '../../../domain/models/template_model.dart';
import '../../services/http_service.dart';
import 'template_repository.dart';

class TemplateTepositoryImpl with HttpRequestMixin implements TemplateRepository {
  final HttpService _http;

  TemplateTepositoryImpl({required HttpService http}) : _http = http;

  final _log = Logger('TemplateRepositoryImpl');

  //cache para transações apresentadas na tela inical (status pending, due today, overdue)
  List<TemplateModel> _listCached = [];
  List<TemplateModel> get listCached => List.unmodifiable(_listCached);
  bool _hasCache = false;

  @override
  Future<Result<void>> create(TemplateCreateDto template) async {
    final result = await safeRequest(request: () => _http.post('/recurrencetemplate', data: template.toBodyRequest()));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 201 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<void>> delete(String id) async {
    final result = await safeRequest(request: () => _http.delete('/recurrencetemplate/$id'));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 201 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<List<TemplateModel>>> list({bool fromCache = false}) async {
    if (fromCache && _hasCache) return Result.ok(listCached);

    final result = await safeRequest(request: () => _http.get('/recurrencetemplate'));

    return result.fold(
      (error) => Result.error(error),
      (value) {
        if (value.statusCode != 200) return Result.error(StatusCodeFailure());
        _listCached = (value.data as List).map((e) => TemplateModel.fromMap(e)).toList();
        _hasCache = true;
        return Result.ok(listCached);
      },
    );
  }

  @override
  Future<Result<void>> update(TemplateUpdateDto template) async {
    final result = await safeRequest(
      request: () => _http.patch('/recurrencetemplate/${template.id}', data: template.toBodyRequest()),
    );

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 201 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }
}
