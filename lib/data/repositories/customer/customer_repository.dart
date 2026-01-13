import '../../../core/utils/result.dart';
import '../../../domain/dtos/customer_upsert_dto.dart';
import '../../../domain/models/customer_model.dart';

abstract class CustomerRepository {
  Future<Result<void>> create({required CustomerCreateDto customer});
  Future<Result<void>> update({required CustomerUpdateDto customer});
  Future<Result<void>> toggleStatus({required String id, required bool active});
  // Future<Result<CustomerModel>> getById({required String id});
  Future<Result<List<CustomerModel>>> getAll({bool fromCache = false});
}
