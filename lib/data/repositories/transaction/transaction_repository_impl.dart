import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/mixins/http_request_mixin.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../../domain/dtos/transaction_upsert_dto.dart';
import '../../../domain/enum/transaction_enum.dart';
import '../../../domain/models/transaction_model.dart';
import '../../services/http_service.dart';
import 'transaction_repository.dart';

class TransactionRepositoryImpl with HttpRequestMixin implements TransactionRepository {
  final HttpService _http;

  TransactionRepositoryImpl({required HttpService http}) : _http = http;

  final _log = Logger('TransactionRepositoryImpl');

  //cache para transações apresentadas na tela inical (status pending, due today, overdue)
  List<TransactionModel> _homeTransactionsCached = [];
  List<TransactionModel> get homeTransactionsCached => List.unmodifiable(_homeTransactionsCached);
  bool _hasHomeCache = false;

  @override
  Future<Result<String>> create(TransactionCreateDto transaction) async {
    final result = await safeRequest(request: () => _http.post('/transaction', data: transaction.toBodyRequest()));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 201 ? Result.ok(value.data['id']) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<void>> uploadFiles({required PlatformFile file, required String id}) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromFileSync(file.path!, filename: file.name),
    });
    final result = await safeRequest(request: () => _http.post('/transaction/$id/attachment', data: formData));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 201 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<void>> delete({required String id}) async {
    final result = await safeRequest(request: () => _http.delete('/transaction/$id'));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 204 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<List<TransactionModel>>> getAll({bool fromCache = false}) async {
    if (fromCache && _hasHomeCache) return Result.ok(homeTransactionsCached);

    //TODO criar parametres
    final result = await safeRequest(request: () => _http.get('/transaction'));

    return result.fold(
      (error) => Result.error(error),
      (value) {
        if (value.statusCode != 200) return Result.error(StatusCodeFailure());
        _homeTransactionsCached = (value.data['data'] as List).map((e) => TransactionModel.fromMap(e)).toList();
        _hasHomeCache = true;
        return Result.ok(homeTransactionsCached);
      },
    );
  }

  @override
  Future<Result<TransactionModel>> getOne({required String id}) async {
    final result = await safeRequest(request: () => _http.get('/transaction/$id'));

    return result.fold(
      (error) => Result.error(error),
      (value) {
        if (value.statusCode != 200) return Result.error(StatusCodeFailure());
        return Result.ok(TransactionModel.fromMap(value.data));
      },
    );
  }

  @override
  Future<Result<void>> getStats() async {
    final result = await safeRequest(request: () => _http.get('/transaction/stats'));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 200 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<void>> update(TransactionUpdateDto transaction) async {
    final result = await safeRequest(
      request: () => _http.patch('/transaction/${transaction.id}', data: transaction.toBodyRequest()),
    );

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 200 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<void>> updateBatchStatus({required List<String> ids, required Map<String, dynamic> body}) async {
    final result = await safeRequest(request: () => _http.patch('/transaction/batch/status', data: body));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 200 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<void>> updateStatus({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final result = await safeRequest(request: () => _http.patch('/transaction/status/$id', data: body));

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 200 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<void>> deleteAttachment({required String idAttachment, required String idTransaction}) async {
    final result = await safeRequest(
      request: () => _http.delete('/transaction/$idTransaction/attachment/$idAttachment'),
    );

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 204 ? const Result.ok(null) : Result.error(StatusCodeFailure()),
    );
  }

  @override
  Future<Result<File>> downloadAttachment({
    required String idAttachment,
    required String idTransaction,
    required String fileName,
  }) async {
    final appDir = await getTemporaryDirectory();
    final String savePath = '${appDir.path}/$fileName';
    final result = await safeRequest(
      request: () => _http.download('/transaction/$idTransaction/attachment/$idAttachment', savePath),
    );

    return result.fold(
      (error) => Result.error(error),
      (value) => value.statusCode == 200 ? Result.ok(File(savePath)) : Result.error(StatusCodeFailure()),
    );
  }
}
