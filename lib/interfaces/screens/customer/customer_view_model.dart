import 'package:flutter/material.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/customer/customer_repository.dart';
import '../../../domain/dtos/customer_upsert_dto.dart';
import '../../../domain/models/customer_model.dart';
import '../../../domain/use_cases/list_customers_use_case.dart';

class CustomerViewModel extends ChangeNotifier {
  final CustomerRepository _repository;
  final ListCustomersUseCase _listCustomersUseCase;

  CustomerViewModel({
    required CustomerRepository repository,
    required ListCustomersUseCase listCustomersUseCase,
  }) : _repository = repository,
       _listCustomersUseCase = listCustomersUseCase {
    listCustomers = Command0<void>(_listCustomers);
    createCustomer = Command1<void, CustomerCreateDto>(_createCustomer);
    updateCustomer = Command1<void, CustomerUpdateDto>(_updateCustomer);
    toggleStatus = Command1<void, CustomerModel>(_toggleStatus);
  }

  final List<CustomerModel> _customers = [];

  List<CustomerModel> get customers => _customers;

  late Command0<void> listCustomers;
  late Command1<void, CustomerCreateDto> createCustomer;
  late Command1<void, CustomerUpdateDto> updateCustomer;
  late Command1<void, CustomerModel> toggleStatus;

  Future<Result<void>> _listCustomers() async => (await _listCustomersUseCase.getAll()).fold(
    (error) => Result.error(error),
    (value) {
      _customers.clear();
      _customers.addAll(value);
      notifyListeners();
      return const Result.ok(null);
    },
  );

  Future<Result<void>> _createCustomer(CustomerCreateDto customer) async =>
      (await _repository.create(customer: customer)).fold(
        (error) => Result.error(error),
        (value) {
          listCustomers.execute();
          return const Result.ok(null);
        },
      );

  Future<Result<void>> _updateCustomer(CustomerUpdateDto customer) async =>
      (await _repository.update(customer: customer)).fold(
        (error) => Result.error(error),
        (value) {
          listCustomers.execute();
          return const Result.ok(null);
        },
      );

  Future<Result<void>> _toggleStatus(CustomerModel customer) async =>
      (await _repository.toggleStatus(id: customer.id, active: !customer.active)).fold(
        (error) => Result.error(error),
        (value) {
          listCustomers.execute();
          notifyListeners();
          return const Result.ok(null);
        },
      );

  @override
  void dispose() {
    listCustomers.dispose();
    createCustomer.dispose();
    updateCustomer.dispose();
    toggleStatus.dispose();
    super.dispose();
  }
}
