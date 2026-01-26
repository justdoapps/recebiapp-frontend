import '../../../core/utils/result.dart';
import '../../../domain/dtos/transaction_upsert_dto.dart';
import '../../../domain/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<Result<void>> create(TransactionCreateDto transaction);
  Future<Result<void>> update(TransactionUpdateDto transaction);
  Future<Result<void>> updateStatus({required String id, required Map<String, dynamic> body});
  Future<Result<void>> updateBatchStatus({required List<String> ids, required Map<String, dynamic> body});
  Future<Result<void>> delete({required String id});
  Future<Result<List<TransactionModel>>> getAll({bool fromCache = false});
  Future<Result<TransactionModel>> getOne({required String id});
  Future<Result<void>> getStats(); //TODO definir no backend retorno de dados pra relatorio
}
