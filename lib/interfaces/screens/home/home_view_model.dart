import 'package:flutter/material.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/recurrence/recurrence_repository.dart';
import '../../../data/repositories/transaction/transaction_repository.dart';
import '../../../domain/dtos/recurrence_upsert_dto.dart';
import '../../../domain/dtos/transaction_upsert_dto.dart';
import '../../../domain/enum/customer_type_enum.dart';
import '../../../domain/enum/transaction_enum.dart';
import '../../../domain/models/customer_model.dart';
import '../../../domain/models/template_model.dart';
import '../../../domain/models/transaction_model.dart';
import '../../../domain/use_cases/list_customers_use_case.dart';
import '../../../domain/use_cases/template_list_use_case.dart';

typedef UpdateStatusArgs = ({TransactionModel transaction, TransactionStatus status, DateTime? paymentDate});
typedef BatchUpdateStatusArgs = ({
  List<TransactionModel> transactions,
  TransactionStatus status,
  DateTime? paymentDate,
});

class HomeViewModel extends ChangeNotifier {
  final TransactionRepository _repository;
  final ListCustomersUseCase _listCustomersUseCase;
  final TemplateListUseCase _templateListUseCase;
  final RecurrenceRepository _recurrenceRepository;

  HomeViewModel({
    required TransactionRepository repository,
    required ListCustomersUseCase listCustomersUseCase,
    required TemplateListUseCase templateListUseCase,
    required RecurrenceRepository recurrenceRepository,
  }) : _repository = repository,
       _listCustomersUseCase = listCustomersUseCase,
       _templateListUseCase = templateListUseCase,
       _recurrenceRepository = recurrenceRepository {
    listTransactions = Command0<void>(_listTransactions);
    listCustomers = Command0<void>(_listCustomers);
    createTransaction = Command1<void, TransactionCreateDto>(_createTransaction);
    updateTransaction = Command1<void, TransactionUpdateDto>(_updateTransaction);
    deleteTransaction = Command1<void, TransactionModel>(_deleteTransaction);
    updateStatus = Command1<void, UpdateStatusArgs>(_updateStatus);
    batchUpdateStatus = Command1<void, BatchUpdateStatusArgs>(_batchUpdateStatus);
    listTemplates = Command0<void>(_listTemplates);
    createRecurrence = Command1<void, RecurrenceCreateDto>(_createRecurrence);
  }

  List<TransactionModel> _allTransactions = [];
  List<TransactionModel> _filteredTransactions = [];
  String _filterByNameCustomer = '';
  List<CustomerModel> _customers = [];
  List<TemplateModel> _templates = [];

  List<TransactionModel> get filteredTransactions => List.unmodifiable(_filteredTransactions);
  List<CustomerModel> get customers => List.unmodifiable(
    _customers.where((c) => c.type == CustomerType.CUSTOMER || c.type == CustomerType.BOTH).toList(),
  );
  List<CustomerModel> get suppliers => List.unmodifiable(
    _customers.where((c) => c.type == CustomerType.SUPPLIER || c.type == CustomerType.BOTH).toList(),
  );
  List<TemplateModel> get templates => List.unmodifiable(_templates);

  void filterTransactionsByNameCustomer({String name = ''}) {
    _filteredTransactions.clear();
    _filteredTransactions = List<TransactionModel>.from(_allTransactions);
    if (name.isNotEmpty) {
      _filteredTransactions = _filteredTransactions
          .where((c) => c.customer.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }

    _filterByNameCustomer = name;
    notifyListeners();
  }

  final Set<TransactionModel> _selectedTransactions = {};
  List<TransactionModel> get selectedTransactions => List.unmodifiable(_selectedTransactions);
  bool get isSelectionMode => _selectedTransactions.isNotEmpty;
  bool isSelected(TransactionModel transaction) => _selectedTransactions.contains(transaction);

  void toggleSelection(TransactionModel transaction) {
    if (_selectedTransactions.contains(transaction)) {
      _selectedTransactions.remove(transaction);
    } else {
      _selectedTransactions.add(transaction);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedTransactions.clear();
    notifyListeners();
  }

  late Command0<void> listTransactions;
  late Command0<void> listCustomers;
  late Command0<void> listTemplates;
  late Command1<void, RecurrenceCreateDto> createRecurrence;
  late Command1<void, TransactionCreateDto> createTransaction;
  late Command1<void, TransactionUpdateDto> updateTransaction;
  late Command1<void, TransactionModel> deleteTransaction;
  late Command1<void, UpdateStatusArgs> updateStatus;
  late Command1<void, BatchUpdateStatusArgs> batchUpdateStatus;

  Future<Result<void>> _listTransactions() async => (await _repository.getAll()).fold(
    (error) => Result.error(error),
    (value) {
      _allTransactions.clear();
      _allTransactions = List<TransactionModel>.from(value);
      filterTransactionsByNameCustomer(name: _filterByNameCustomer);
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

  Future<Result<void>> _createRecurrence(RecurrenceCreateDto recurrence) async =>
      (await _recurrenceRepository.create(recurrence)).fold(
        (error) => Result.error(error),
        (value) {
          //TODO: criar transação a partir do template ou aviso visual para usuário da primeira data
          return const Result.ok(null);
        },
      );

  Future<Result<void>> _createTransaction(TransactionCreateDto transaction) async =>
      (await _repository.create(transaction)).fold(
        (error) => Result.error(error),
        (value) {
          listTransactions.execute();
          return const Result.ok(null);
        },
      );

  Future<Result<void>> _updateTransaction(TransactionUpdateDto transaction) async =>
      (await _repository.update(transaction)).fold(
        (error) => Result.error(error),
        (value) {
          listTransactions.execute();
          return const Result.ok(null);
        },
      );

  Future<Result<void>> _deleteTransaction(TransactionModel transaction) async =>
      (await _repository.delete(id: transaction.id)).fold(
        (error) => Result.error(error),
        (value) {
          listTransactions.execute();
          return const Result.ok(null);
        },
      );

  Future<Result<void>> _updateStatus(UpdateStatusArgs args) async =>
      (await _repository.updateStatus(
        id: args.transaction.id,
        body: {
          'status': args.status.name,
          if (args.paymentDate != null) 'paidAt': args.paymentDate!.toIso8601String(),
        },
      )).fold(
        (error) => Result.error(error),
        (value) {
          listTransactions.execute();
          return const Result.ok(null);
        },
      );

  Future<Result<void>> _batchUpdateStatus(BatchUpdateStatusArgs args) async =>
      (await _repository.updateBatchStatus(
        ids: args.transactions.map((e) => e.id).toList(),
        body: {
          'ids': args.transactions.map((e) => e.id).toList(),
          'status': args.status.name,
          if (args.paymentDate != null) 'paidAt': args.paymentDate!.toIso8601String(),
        },
      )).fold(
        (error) => Result.error(error),
        (value) {
          listTransactions.execute();
          clearSelection();
          return const Result.ok(null);
        },
      );

  @override
  void dispose() {
    listTransactions.dispose();
    listCustomers.dispose();
    createTransaction.dispose();
    updateTransaction.dispose();
    deleteTransaction.dispose();
    updateStatus.dispose();
    batchUpdateStatus.dispose();
    super.dispose();
  }
}
