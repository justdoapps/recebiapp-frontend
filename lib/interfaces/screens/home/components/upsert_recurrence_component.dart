import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/dialog_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../core/extensions/message_extension.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../../../domain/dtos/recurrence_upsert_dto.dart';
import '../../../../domain/enum/frequency_enum.dart';
import '../../../../domain/enum/transaction_enum.dart';
import '../../../../domain/models/customer_model.dart';
import '../../../../domain/models/template_model.dart';
import '../../../core/adaptive_date_picker.dart';
import '../../../core/app_gradient_button.dart';
import '../../../core/app_input_stack.dart';
import '../../customer/lang/customer_localization_ext.dart';
import '../../recurrence_template/lang/template_localization_ext.dart';
import '../home_view_model.dart';
import '../lang/home_localization_ext.dart';

class UpsertRecurrenceComponent extends StatefulWidget {
  const UpsertRecurrenceComponent({super.key});

  @override
  State<UpsertRecurrenceComponent> createState() => _UpsertRecurrenceComponentState();
}

class _UpsertRecurrenceComponentState extends State<UpsertRecurrenceComponent> with LoadingMixin {
  late final HomeViewModel _vm;
  final _formKey = GlobalKey<FormState>();
  final _descriptionEC = TextEditingController();
  final _amountEC = TextEditingController();
  final _customerEC = TextEditingController();
  final FocusNode _customerFN = FocusNode();
  final _templateEC = TextEditingController();
  final FocusNode _templateFN = FocusNode();
  final _intervalDaysEC = TextEditingController(text: '1');
  final _dayOfMonthEC = TextEditingController();
  Frequency _frequency = Frequency.INTERVAL;
  int? _intervalDays = 1;
  int? _dayOfMonth;
  FrequencyWeekly? _dayOfWeek;

  CustomerModel? _customer;
  TemplateModel? _template;
  DateTime _startDate = DateTime.now();
  TransactionType _type = TransactionType.INCOME;

  @override
  void initState() {
    super.initState();
    _vm = context.read<HomeViewModel>();
    _vm.listCustomers.execute();
    _vm.listTemplates.execute();
    _vm.createRecurrence.addListener(_onCreateListener);
    _customerFN.addListener(_onCustomerListener);
    _templateFN.addListener(_onTemplateListener);
  }

  @override
  void dispose() {
    _descriptionEC.dispose();
    _amountEC.dispose();
    _customerEC.dispose();
    _customerFN.dispose();
    _templateEC.dispose();
    _templateFN.dispose();
    _formKey.currentState?.dispose();
    _intervalDaysEC.dispose();
    _dayOfMonthEC.dispose();
    super.dispose();
  }

  void _onCreateListener() {
    _vm.createRecurrence.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.createRecurrence.error) {
      context.showMessage(title: context.words.errorCreateRecurrence, type: MessageType.error, position: .top);
      _vm.createRecurrence.clearResult();
    } else if (_vm.createRecurrence.completed) {
      context.showMessage(title: context.words.recurrenceCreated);
      _vm.createRecurrence.clearResult();
      context.pop();
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _vm.createRecurrence.execute(
      RecurrenceCreateDto(
        description: _descriptionEC.text,
        amount: _amountEC.text.toCents(),
        customerId: _customer!.id,
        startDate: _startDate,
        type: _type,
        frequency: _frequency,
        intervalDays: _frequency == Frequency.INTERVAL ? _intervalDays : null,
        dayOfMonth: _frequency == Frequency.MONTHLY ? _dayOfMonth : null,
        dayOfWeek: _frequency == Frequency.WEEKLY ? _dayOfWeek?.getInt() : null,
      ),
    );
  }

  void _onCustomerListener() {
    if (_customerFN.hasFocus) return;
    if (_customer == null) {
      setState(() {
        _customerEC.clear();
      });
    }
  }

  void _onTemplateListener() {
    if (_templateFN.hasFocus) return;
    if (_template == null) {
      setState(() {
        _templateEC.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const .symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: [
                Text(
                  context.words.newData,
                  style: context.textTheme.largeBold,
                  textAlign: .center,
                ),
                const SizedBox(height: 10),

                LayoutBuilder(
                  builder: (context, constraints) => DropdownMenu<TemplateModel>(
                    width: constraints.maxWidth,
                    label: Text(context.words.templateRecurrence),
                    leadingIcon: _template == null
                        ? const Icon(Icons.search)
                        : Icon(
                            Icons.check_circle,
                            color: context.theme.colorScheme.primary,
                          ),
                    enableFilter: true,
                    requestFocusOnTap: true,
                    initialSelection: _template,
                    controller: _templateEC,
                    focusNode: _templateFN,
                    keyboardType: .name,
                    textStyle: context.textTheme.small,
                    onSelected: (value) {
                      setState(() {
                        _template = value;
                      });
                    },

                    dropdownMenuEntries: _type == TransactionType.INCOME
                        ? _vm.templatesIncome
                              .map<DropdownMenuEntry<TemplateModel>>(
                                (x) => DropdownMenuEntry<TemplateModel>(value: x, label: x.name),
                              )
                              .toList()
                        : _vm.templatesExpense
                              .map<DropdownMenuEntry<TemplateModel>>(
                                (x) => DropdownMenuEntry<TemplateModel>(value: x, label: x.name),
                              )
                              .toList(),
                  ),
                ),

                RadioGroup<TransactionType>(
                  groupValue: _type,
                  onChanged: (value) {
                    setState(() {
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
                        label: context.words.startDate,
                        controller: TextEditingController(text: _startDate.toLocaleDate(context.locale)),
                        onTap: () async {
                          context.showBottomSheet(
                            child: SafeArea(
                              child: Column(
                                mainAxisSize: .min,
                                children: [
                                  AdaptiveDatePicker(
                                    initialDate: _startDate,
                                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                                    onDateChanged: (value) {
                                      setState(() {
                                        _startDate = value;
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

                LayoutBuilder(
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

                LayoutBuilder(
                  builder: (context, constraints) => DropdownMenu<Frequency>(
                    width: constraints.maxWidth,
                    label: Text(context.words.frequency),
                    leadingIcon: Icon(Icons.timer_outlined, color: context.theme.colorScheme.primary),
                    requestFocusOnTap: true,
                    initialSelection: _frequency,
                    textStyle: context.textTheme.small,
                    onSelected: (value) {
                      setState(() {
                        if (value != null) {
                          _frequency = value;
                          _dayOfMonthEC.clear();
                          _intervalDaysEC.clear();
                          _dayOfWeek = null;
                          _intervalDays = null;
                          _dayOfMonth = null;
                          if (_frequency == Frequency.WEEKLY) {
                            _dayOfWeek = FrequencyWeekly.MONDAY;
                          } else if (_frequency == Frequency.MONTHLY) {
                            _dayOfMonth = 1;
                            _dayOfMonthEC.text = '1';
                          } else if (_frequency == Frequency.INTERVAL) {
                            _intervalDays = 1;
                            _intervalDaysEC.text = '1';
                          }
                        }
                      });
                    },

                    dropdownMenuEntries: Frequency.values
                        .map((x) => DropdownMenuEntry(value: x, label: x.getContextName(context)))
                        .toList(),
                  ),
                ),

                Row(
                  mainAxisAlignment: .spaceAround,
                  children: [
                    if (_frequency == Frequency.INTERVAL) ...[
                      IconButton.filledTonal(
                        onPressed: () {
                          final day = int.tryParse(_intervalDaysEC.text);
                          if (day != null && day > 1) {
                            _intervalDaysEC.text = (day - 1).toString();
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const .only(top: 20.0),
                          child: AppInputStack(
                            controller: _intervalDaysEC,
                            label: context.words.intervalDays,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (_frequency != Frequency.INTERVAL) return null;
                              if (value == null || value.isEmpty) {
                                return context.words.requiredField;
                              }
                              final day = int.tryParse(value);
                              if (day == null || day < 1 || day > 365) {
                                return context.words.invalidIntervalDays;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () {
                          final day = int.tryParse(_intervalDaysEC.text);
                          if (day != null && day < 365) {
                            _intervalDaysEC.text = (day + 1).toString();
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                    if (_frequency == Frequency.MONTHLY) ...[
                      IconButton.filledTonal(
                        onPressed: () {
                          final day = int.tryParse(_dayOfMonthEC.text);
                          if (day != null && day > 1) {
                            _dayOfMonthEC.text = (day - 1).toString();
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const .only(top: 20.0),
                          child: AppInputStack(
                            controller: _dayOfMonthEC,
                            label: context.words.dayOfMonth,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            validator: (value) {
                              if (_frequency != Frequency.MONTHLY) return null;
                              if (value == null || value.isEmpty) {
                                return context.words.requiredField;
                              }
                              final day = int.tryParse(value);
                              if (day == null || day < 1 || day > 31) {
                                return context.words.invalidDayOfMonth;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      IconButton.filledTonal(
                        onPressed: () {
                          final day = int.tryParse(_dayOfMonthEC.text);
                          if (day != null && day < 31) {
                            _dayOfMonthEC.text = (day + 1).toString();
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                    if (_frequency == Frequency.WEEKLY) ...[
                      Expanded(
                        child: Padding(
                          padding: const .only(top: 20.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) => DropdownMenu<FrequencyWeekly>(
                              width: constraints.maxWidth,
                              menuHeight: 200,
                              label: Text(context.words.frequency),
                              leadingIcon: const SizedBox(width: 20),
                              requestFocusOnTap: true,
                              initialSelection: FrequencyWeekly.MONDAY,
                              textStyle: context.textTheme.small,
                              onSelected: (value) {
                                if (value != null) _dayOfWeek = value;
                              },

                              dropdownMenuEntries: FrequencyWeekly.values
                                  .map((x) => DropdownMenuEntry(value: x, label: x.getContextName(context)))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
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
