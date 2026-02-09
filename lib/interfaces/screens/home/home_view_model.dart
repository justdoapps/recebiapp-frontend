import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/command.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/recurrence/recurrence_repository.dart';
import '../../../data/repositories/transaction/transaction_repository.dart';
import '../../../data/services/notification_service.dart';
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

typedef TransactionCreateArgs = ({
  TransactionCreateDto transaction,
  PlatformFile? file,
});
typedef TransactionUpdateArgs = ({
  TransactionUpdateDto transaction,
  PlatformFile? file,
});

class HomeViewModel extends ChangeNotifier {
  final TransactionRepository _repository;
  final ListCustomersUseCase _listCustomersUseCase;
  final TemplateListUseCase _templateListUseCase;
  final RecurrenceRepository _recurrenceRepository;
  final NotificationService _notificationService;

  HomeViewModel({
    required TransactionRepository repository,
    required ListCustomersUseCase listCustomersUseCase,
    required TemplateListUseCase templateListUseCase,
    required RecurrenceRepository recurrenceRepository,
    required NotificationService notificationService,
  }) : _repository = repository,
       _listCustomersUseCase = listCustomersUseCase,
       _templateListUseCase = templateListUseCase,
       _recurrenceRepository = recurrenceRepository,
       _notificationService = notificationService {
    listTransactions = Command0<void>(_listTransactions);
    listCustomers = Command0<void>(_listCustomers);
    createTransaction = Command1<void, TransactionCreateArgs>(_createTransaction);
    updateTransaction = Command1<void, TransactionUpdateArgs>(_updateTransaction);
    deleteTransaction = Command1<void, TransactionModel>(_deleteTransaction);
    updateStatus = Command1<void, UpdateStatusArgs>(_updateStatus);
    batchUpdateStatus = Command1<void, BatchUpdateStatusArgs>(_batchUpdateStatus);
    listTemplates = Command0<void>(_listTemplates);
    createRecurrence = Command1<void, RecurrenceCreateDto>(_createRecurrence);
    deleteAttachment = Command1<void, TransactionModel>(_deleteAttachment);
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
  late Command1<void, TransactionCreateArgs> createTransaction;
  late Command1<void, TransactionUpdateArgs> updateTransaction;
  late Command1<void, TransactionModel> deleteTransaction;
  late Command1<void, UpdateStatusArgs> updateStatus;
  late Command1<void, BatchUpdateStatusArgs> batchUpdateStatus;

  Future<Result<void>> _listTransactions() async => (await _repository.getAll()).fold(
    (error) => Result.error(error),
    (value) {
      _allTransactions.clear();
      _allTransactions = List<TransactionModel>.from(value);
      _notificationService.scheduleNotifications(_allTransactions);
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

  Future<Result<void>> _createTransaction(TransactionCreateArgs args) async =>
      (await _repository.create(args.transaction)).fold(
        (error) => Result.error(error),
        (newId) async {
          if (args.file != null) {
            final attachmentResult = await _repository.uploadFiles(id: newId, file: args.file!);
            listTransactions.execute();
            return attachmentResult.fold(
              (error) => Result.error(AttachmentFailure()),
              (value) => const Result.ok(null),
            );
          }
          listTransactions.execute();
          return const Result.ok(null);
        },
      );

  Future<Result<void>> _updateTransaction(TransactionUpdateArgs args) async =>
      (await _repository.update(args.transaction)).fold(
        (error) => Result.error(error),
        (value) async {
          if (args.file != null) {
            final attachmentResult = await _repository.uploadFiles(id: args.transaction.id, file: args.file!);
            listTransactions.execute();
            return attachmentResult.fold(
              (error) => Result.error(AttachmentFailure()),
              (value) => const Result.ok(null),
            );
          }
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

  late Command1<void, TransactionModel> deleteAttachment;
  Future<Result<void>> _deleteAttachment(TransactionModel transaction) async =>
      (await _repository.deleteAttachment(
        idAttachment: transaction.attachmentId!,
        idTransaction: transaction.id,
      )).fold(
        (error) => Result.error(error),
        (value) {
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
    deleteAttachment.dispose();
    super.dispose();
  }
}
