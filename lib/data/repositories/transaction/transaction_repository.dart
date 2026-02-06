import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../../core/utils/result.dart';
import '../../../domain/dtos/transaction_upsert_dto.dart';
import '../../../domain/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<Result<String>> create(TransactionCreateDto transaction);
  Future<Result<void>> update(TransactionUpdateDto transaction);
  Future<Result<void>> updateStatus({required String id, required Map<String, dynamic> body});
  Future<Result<void>> updateBatchStatus({required List<String> ids, required Map<String, dynamic> body});
  Future<Result<void>> delete({required String id});
  Future<Result<List<TransactionModel>>> getAll({bool fromCache = false});
  Future<Result<TransactionModel>> getOne({required String id});
  Future<Result<void>> getStats(); //TODO definir no backend retorno de dados pra relatorio
  Future<Result<void>> uploadFiles({required String id, required PlatformFile file});
  Future<Result<void>> deleteAttachment({required String idAttachment, required String idTransaction});
  Future<Result<File>> downloadAttachment({
    required String idAttachment,
    required String idTransaction,
    required String fileName,
  });
}
