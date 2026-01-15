import 'package:flutter/material.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/customer/customer_repository.dart';
import '../../../domain/dtos/customer_upsert_dto.dart';
import '../../../domain/enum/customer_type_enum.dart';
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

  List<CustomerModel> _allCustomers = [];
  List<CustomerModel> _filteredCustomers = [];
  List<CustomerModel> get customers => List.unmodifiable(_filteredCustomers);
  List<CustomerModel> get typeCustomer => List.unmodifiable(
    _filteredCustomers.where((e) => e.type == CustomerType.CUSTOMER || e.type == CustomerType.BOTH).toList(),
  );
  List<CustomerModel> get typeSupplier => List.unmodifiable(
    _filteredCustomers.where((e) => e.type == CustomerType.SUPPLIER || e.type == CustomerType.BOTH).toList(),
  );
  List<CustomerModel> get typeBoth =>
      List.unmodifiable(_filteredCustomers.where((e) => e.type == CustomerType.BOTH).toList());

  String _filterString = '';

  void filterCustomers({String query = ''}) {
    _filteredCustomers.clear();
    _filteredCustomers = List<CustomerModel>.from(_allCustomers);
    if (query.isNotEmpty) {
      _filteredCustomers = _filteredCustomers
          .where(
            (c) =>
                c.name.toLowerCase().contains(query.toLowerCase()) ||
                (c.document?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
                (c.phone?.toLowerCase().contains(query.toLowerCase()) ?? false),
          )
          .toList();
    }

    _filterString = query;
    notifyListeners();
  }

  late Command0<void> listCustomers;
  late Command1<void, CustomerCreateDto> createCustomer;
  late Command1<void, CustomerUpdateDto> updateCustomer;
  late Command1<void, CustomerModel> toggleStatus;

  //TODO fazer a tela de detalhes do cliente (transactions e recurrences) e um relatorio

  Future<Result<void>> _listCustomers() async => (await _listCustomersUseCase.getAll()).fold(
    (error) => Result.error(error),
    (value) {
      _allCustomers.clear();
      _allCustomers = List<CustomerModel>.from(value);
      filterCustomers(query: _filterString);
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
