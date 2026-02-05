import 'package:flutter/material.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/recurrence/recurrence_repository.dart';
import '../../../domain/dtos/recurrence_upsert_dto.dart';
import '../../../domain/enum/customer_type_enum.dart';
import '../../../domain/enum/transaction_enum.dart';
import '../../../domain/models/customer_model.dart';
import '../../../domain/models/recurrence_model.dart';
import '../../../domain/models/template_model.dart';
import '../../../domain/use_cases/list_customers_use_case.dart';
import '../../../domain/use_cases/template_list_use_case.dart';

class RecurrenceViewModel extends ChangeNotifier {
  final RecurrenceRepository _repository;
  final ListCustomersUseCase _listCustomersUseCase;
  final TemplateListUseCase _templateListUseCase;

  RecurrenceViewModel({
    required RecurrenceRepository repository,
    required ListCustomersUseCase listCustomersUseCase,
    required TemplateListUseCase templateListUseCase,
  }) : _repository = repository,
       _listCustomersUseCase = listCustomersUseCase,
       _templateListUseCase = templateListUseCase {
    list = Command0<void>(_list);
    create = Command1<void, RecurrenceCreateDto>(_create);
    update = Command1<void, RecurrenceUpdateDto>(_update);
    listCustomers = Command0<void>(_listCustomers);
    listTemplates = Command0<void>(_listTemplates);
  }

  List<RecurrenceModel> _recurrences = [];
  List<RecurrenceModel> get recurrences => List.unmodifiable(_recurrences);

  List<CustomerModel> _customers = [];
  List<TemplateModel> _templates = [];
  List<CustomerModel> get customers => List.unmodifiable(
    _customers.where((c) => c.type == CustomerType.CUSTOMER || c.type == CustomerType.BOTH).toList(),
  );
  List<CustomerModel> get suppliers => List.unmodifiable(
    _customers.where((c) => c.type == CustomerType.SUPPLIER || c.type == CustomerType.BOTH).toList(),
  );
  List<TemplateModel> getTemplates(TransactionType type) =>
      List.unmodifiable(_templates.where((t) => t.type == type).toList());

  late Command0<void> list;
  late Command1<void, RecurrenceCreateDto> create;
  late Command1<void, RecurrenceUpdateDto> update;
  late Command0<void> listCustomers;
  late Command0<void> listTemplates;

  Future<Result<void>> _list() async => (await _repository.list()).fold(
    (error) => Result.error(error),
    (value) {
      _recurrences.clear();
      _recurrences = List<RecurrenceModel>.from(value);
      notifyListeners();
      return const Result.ok(null);
    },
  );

  Future<Result<void>> _create(RecurrenceCreateDto recurrence) async => (await _repository.create(recurrence)).fold(
    (error) => Result.error(error),
    (value) {
      list.execute();
      notifyListeners();
      return const Result.ok(null);
    },
  );

  Future<Result<void>> _update(RecurrenceUpdateDto recurrence) async => (await _repository.update(recurrence)).fold(
    (error) => Result.error(error),
    (value) {
      list.execute();
      notifyListeners();
      return const Result.ok(null);
    },
  );

  Future<Result<void>> _listCustomers() async => (await _listCustomersUseCase.getFromCacheWithoutInactive()).fold(
    (error) => Result.error(error),
    (value) {
      _customers.clear();
      _customers = List<CustomerModel>.from(value);
      return const Result.ok(null);
    },
  );

  Future<Result<void>> _listTemplates() async => (await _templateListUseCase.listFromCacheWithoutInactive()).fold(
    (error) => Result.error(error),
    (value) {
      _templates.clear();
      _templates = List<TemplateModel>.from(value);
      return const Result.ok(null);
    },
  );

  @override
  void dispose() {
    list.dispose();
    create.dispose();
    update.dispose();
    super.dispose();
  }
}
