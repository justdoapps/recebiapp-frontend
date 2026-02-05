import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/dialog_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../core/extensions/message_extension.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../../../domain/dtos/transaction_upsert_dto.dart';
import '../../../../domain/enum/transaction_enum.dart';
import '../../../../domain/models/customer_model.dart';
import '../../../../domain/models/transaction_model.dart';
import '../../../core/adaptive_date_picker.dart';
import '../../../core/app_gradient_button.dart';
import '../../../core/app_input_stack.dart';
import '../../../core/loader_local.dart';
import '../../customer/lang/customer_localization_ext.dart';
import '../home_view_model.dart';
import '../lang/home_localization_ext.dart';

class UpsertTransactionComponent extends StatefulWidget {
  const UpsertTransactionComponent({super.key, this.transaction});

  final TransactionModel? transaction;

  @override
  State<UpsertTransactionComponent> createState() => _UpsertTransactionComponentState();
}

class _UpsertTransactionComponentState extends State<UpsertTransactionComponent> with LoadingMixin {
  late final HomeViewModel _vm;
  final _formKey = GlobalKey<FormState>();
  final _descriptionEC = TextEditingController();
  final _amountEC = TextEditingController();
  final _internalNoteEC = TextEditingController();
  final _customerNoteEC = TextEditingController();
  final _paymentInfoEC = TextEditingController();
  final _customerEC = TextEditingController();
  final FocusNode _customerFN = FocusNode();

  CustomerModel? _customer;
  DateTime _dueDate = DateTime.now();
  TransactionType _type = TransactionType.INCOME;
  TransactionStatus _status = TransactionStatus.PENDING;
  final files = <PlatformFile>[];

  @override
  void initState() {
    _vm = context.read<HomeViewModel>();

    if (widget.transaction != null) {
      _descriptionEC.text = widget.transaction!.description;
      _amountEC.text = widget.transaction!.amount.centsToString();
      _internalNoteEC.text = widget.transaction!.internalNote ?? '';
      _customerNoteEC.text = widget.transaction!.customerNote ?? '';
      _paymentInfoEC.text = widget.transaction!.paymentInfo ?? '';
      _dueDate = widget.transaction!.dueDate;
      _type = widget.transaction!.type;
      _customer = widget.transaction!.customer;
      _status = widget.transaction!.status;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _amountEC.text = CurrencyTextInputFormatter.simpleCurrency(locale: context.locale).formatString(
            widget.transaction!.amount.centsToString(),
          );
        }
      });
    }

    _vm.createTransaction.addListener(_onCreateListener);
    _vm.updateTransaction.addListener(_onUpdateListener);
    _customerFN.addListener(_onCustomerListener);
    _vm.listCustomers.addListener(_onListCustomersListener);

    _vm.listCustomers.execute();

    super.initState();
  }

  @override
  void dispose() {
    _vm.createTransaction.removeListener(_onCreateListener);
    _vm.updateTransaction.removeListener(_onUpdateListener);
    _customerFN.removeListener(_onCustomerListener);

    _formKey.currentState?.dispose();
    _customerEC.dispose();
    _customerFN.dispose();
    _descriptionEC.dispose();
    _amountEC.dispose();
    _internalNoteEC.dispose();
    _customerNoteEC.dispose();
    _paymentInfoEC.dispose();

    super.dispose();
  }

  void _onCreateListener() {
    _vm.createTransaction.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.createTransaction.error) {
      context.showMessage(title: context.words.errorCreateTransaction, type: MessageType.error, position: .top);
      _vm.createTransaction.clearResult();
    } else if (_vm.createTransaction.completed) {
      context.showMessage(title: context.words.transactionCreated);
      _vm.createTransaction.clearResult();
      context.pop();
    }
  }

  void _onUpdateListener() {
    _vm.updateTransaction.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.updateTransaction.error) {
      context.showMessage(
        title: context.words.errorUpdateTransaction,
        type: MessageType.error,
      );
      _vm.updateTransaction.clearResult();
    } else if (_vm.updateTransaction.completed) {
      context.showMessage(title: context.words.transactionUpdated);
      _vm.updateTransaction.clearResult();
      context.pop();
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (widget.transaction == null) {
      _vm.createTransaction.execute(
        TransactionCreateDto(
          description: _descriptionEC.text,
          amount: _amountEC.text.toCents(),
          internalNote: _internalNoteEC.text.isEmpty ? null : _internalNoteEC.text,
          customerNote: _customerNoteEC.text.isEmpty ? null : _customerNoteEC.text,
          paymentInfo: _paymentInfoEC.text.isEmpty ? null : _paymentInfoEC.text,
          customerId: _customer!.id,
          dueDate: _dueDate,
          type: _type,
          status: _status,
        ),
      );
    } else {
      _vm.updateTransaction.execute(
        TransactionUpdateDto(
          id: widget.transaction!.id,
          description: _descriptionEC.text != widget.transaction!.description ? _descriptionEC.text : null,
          amount: _amountEC.text.toCents() != widget.transaction!.amount ? _amountEC.text.toCents() : null,
          internalNote: _internalNoteEC.text != widget.transaction!.internalNote ? _internalNoteEC.text : null,
          customerNote: _customerNoteEC.text != widget.transaction!.customerNote ? _customerNoteEC.text : null,
          paymentInfo: _paymentInfoEC.text != widget.transaction!.paymentInfo ? _paymentInfoEC.text : null,
          customerId: _customer != widget.transaction!.customer ? _customer!.id : null,
          dueDate: _dueDate != widget.transaction!.dueDate ? _dueDate : null,
          type: _type != widget.transaction!.type ? _type : null,
          status: _status != widget.transaction!.status ? _status : null,
        ),
      );
    }
  }

  void _onCustomerListener() {
    if (_customerFN.hasFocus) return;
    if (_customer == null) {
      setState(() {
        _customerEC.clear();
      });
    }
  }

  final _listCustomersListener = ValueNotifier(false);

  void _onListCustomersListener() {
    _vm.listCustomers.running ? _listCustomersListener.value = true : _listCustomersListener.value = false;
    if (_vm.listCustomers.error) {
      context.showMessage(title: context.words.errorListCustomers, type: MessageType.error);
      _vm.listCustomers.clearResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const .symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: [
                Text(
                  widget.transaction == null ? context.words.newData : context.words.editData,
                  style: context.textTheme.largeBold,
                  textAlign: .center,
                ),
                const SizedBox(height: 10),

                RadioGroup<TransactionType>(
                  groupValue: _type,
                  onChanged: (value) {
                    setState(() {
                      _customer = null;
                      _customerEC.clear();
                      if (value != null) _type = value;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<TransactionType>.adaptive(
                          value: TransactionType.INCOME,
                          title: Text(context.words.income),
                          dense: true,
                          selected: _type == TransactionType.INCOME,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<TransactionType>.adaptive(
                          value: TransactionType.EXPENSE,
                          title: Text(context.words.expense),
                          dense: true,
                          selected: _type == TransactionType.EXPENSE,
                        ),
                      ),
                    ],
                  ),
                ),

                ValueListenableBuilder(
                  valueListenable: _listCustomersListener,
                  builder: (context, value, child) {
                    return LoaderLocal(
                      isLoading: value,
                      child: child!,
                    );
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) => DropdownMenu<CustomerModel>(
                      width: constraints.maxWidth,
                      label: Text(_type == TransactionType.INCOME ? context.words.customer : context.words.supplier),
                      leadingIcon: _customer == null
                          ? const Icon(Icons.search)
                          : Icon(
                              Icons.check_circle,
                              color: context.theme.colorScheme.primary,
                            ),
                      enableFilter: true,
                      requestFocusOnTap: true,
                      initialSelection: _customer,
                      controller: _customerEC,
                      focusNode: _customerFN,
                      keyboardType: .name,
                      textStyle: context.textTheme.small,
                      onSelected: (value) {
                        setState(() {
                          _customer = value;
                        });
                      },

                      dropdownMenuEntries: _type == TransactionType.INCOME
                          ? _vm.customers
                                .map<DropdownMenuEntry<CustomerModel>>(
                                  (x) => DropdownMenuEntry<CustomerModel>(value: x, label: x.name),
                                )
                                .toList()
                          : _vm.suppliers
                                .map<DropdownMenuEntry<CustomerModel>>(
                                  (x) => DropdownMenuEntry<CustomerModel>(
                                    value: x,
                                    label: x.name,
                                    trailingIcon: (x.phone != null || x.document != null)
                                        ? Text((x.phone ?? x.document)!, style: context.textTheme.small)
                                        : null,
                                  ),
                                )
                                .toList(),
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: AppInputStack(
                        label: context.words.amount,
                        controller: _amountEC,
                        inputType: .number,
                        inputFormatters: [
                          CurrencyTextInputFormatter.simpleCurrency(
                            locale: context.locale,
                            decimalDigits: 2,
                            enableNegative: false,
                            maxValue: 999999.99,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AppInputStack(
                        readOnly: true,
                        label: context.words.dueDate,
                        controller: TextEditingController(text: _dueDate.toLocaleDate(context.locale)),
                        onTap: () async {
                          context.showBottomSheet(
                            child: SafeArea(
                              child: Column(
                                mainAxisSize: .min,
                                children: [
                                  AdaptiveDatePicker(
                                    initialDate: _dueDate,
                                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                                    onDateChanged: (value) {
                                      setState(() {
                                        _dueDate = value;
                                      });
                                    },
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: Text(context.words.back),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                AppInputStack(
                  label: context.words.description,
                  controller: _descriptionEC,
                  inputType: .text,
                  lines: 2,
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return context.words.requiredField;
                    }
                    return null;
                  },
                ),
                AppInputStack(
                  label: context.words.paymentInfo,
                  controller: _paymentInfoEC,
                  inputType: .text,
                  lines: 2,
                ),
                AppInputStack(
                  label: context.words.customerNote,
                  controller: _customerNoteEC,
                  inputType: .text,
                  lines: 3,
                ),
                AppInputStack(
                  label: context.words.internalNote,
                  controller: _internalNoteEC,
                  inputType: .text,
                  lines: 3,
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        context.showConfirmationDialog(
                          content: Text(context.words.confirmClearFiles),
                          onConfirm: () {
                            setState(() {
                              files.clear();
                            });
                          },
                        );
                      },
                      icon: const Icon(Icons.clear),
                      label: Text(context.words.clearAll),
                    ),
                    FilledButton.icon(
                      onPressed: () async {
                        if (files.length >= 2) {
                          context.showInformationDialog(
                            content: Text(context.words.toManyFiles),
                          );
                          return;
                        }
                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'pdf', 'doc'],
                        );
                        if (result != null) {
                          setState(() {
                            files.addAll(result.files);
                          });
                        }
                      },
                      icon: const Icon(Icons.attach_file),
                      label: Text(context.words.addFiles),
                    ),
                  ],
                ),
                Wrap(
                  children: files
                      .map(
                        (x) => InkWell(
                          onTap: () {
                            context.showConfirmationDialog(
                              content: Text(context.words.confirmRemoveFile(x.name)),
                              onConfirm: () {
                                setState(() {
                                  files.remove(x);
                                });
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(x.name, style: context.textTheme.verySmallBold, overflow: .ellipsis),
                            subtitle: Text(x.size.bytesToMbString(), style: context.textTheme.verySmall),
                            trailing: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  files.remove(x);
                                });
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const Divider(),
                AppGradientButton(onPressed: _save, label: context.words.save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
