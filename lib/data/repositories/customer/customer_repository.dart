import '../../../core/utils/result.dart';
import '../../../domain/dtos/customer_upsert_dto.dart';
import '../../../domain/models/customer_model.dart';

abstract class CustomerRepository {
  Future<Result<CustomerModel>> create({required CustomerCreateDto customer});
  Future<Result<CustomerModel>> update({
    required CustomerUpdateDto customer,
    required String id,
  });
  Future<Result<CustomerModel>> toggleStatus({
    required String id,
    required bool active,
  });
  Future<Result<CustomerModel>> getById({required String id});
  Future<Result<List<CustomerModel>>> getAll();
}
