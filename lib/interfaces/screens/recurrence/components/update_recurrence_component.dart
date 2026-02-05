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
import '../../../../domain/models/recurrence_model.dart';
import '../../../../domain/models/template_model.dart';
import '../../../core/adaptive_date_picker.dart';
import '../../../core/app_gradient_button.dart';
import '../../../core/app_input_stack.dart';
import '../../../core/loader_local.dart';
import '../../customer/lang/customer_localization_ext.dart';
import '../../home/lang/home_localization_ext.dart';
import '../../recurrence_template/lang/template_localization_ext.dart';
import '../lang/recurrence_localization_ext.dart';
import '../recurrence_view_model.dart';

class UpdateRecurrenceComponent extends StatefulWidget {
  const UpdateRecurrenceComponent({super.key, required this.recurrence});

  final RecurrenceModel recurrence;

  @override
  State<UpdateRecurrenceComponent> createState() => _UpdateRecurrenceComponentState();
}

class _UpdateRecurrenceComponentState extends State<UpdateRecurrenceComponent> with LoadingMixin {
  late final RecurrenceViewModel _vm;
  final _formKey = GlobalKey<FormState>();
  final _descriptionEC = TextEditingController();
  final _amountEC = TextEditingController();
  final _templateEC = TextEditingController();
  final FocusNode _templateFN = FocusNode();
  final _intervalDaysEC = TextEditingController();
  final _dayOfMonthEC = TextEditingController();
  Frequency _frequency = Frequency.INTERVAL;
  int? _intervalDays;
  int? _dayOfMonth;
  FrequencyWeekly? _dayOfWeek;

  late CustomerModel _customer;
  TemplateModel? _template;
  DateTime _startDate = DateTime.now();
  TransactionType _type = TransactionType.INCOME;

  @override
  void initState() {
    super.initState();
    _vm = context.read<RecurrenceViewModel>();

    _descriptionEC.text = widget.recurrence.description;
    _amountEC.text = widget.recurrence.amount.centsToString();
    _customer = widget.recurrence.customer;
    _template = widget.recurrence.template;
    _startDate = widget.recurrence.startDate;
    _type = widget.recurrence.type;
    _frequency = widget.recurrence.frequency;
    _intervalDays = widget.recurrence.intervalDays;
    _dayOfMonth = widget.recurrence.dayOfMonth;
    if (_dayOfMonth != null) _dayOfMonthEC.text = _dayOfMonth.toString();
    if (_intervalDays != null) _intervalDaysEC.text = _intervalDays.toString();
    _dayOfWeek = widget.recurrence.dayOfWeek != null ? FrequencyWeekly.values[widget.recurrence.dayOfWeek!] : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _amountEC.text = CurrencyTextInputFormatter.simpleCurrency(locale: context.locale).formatString(
          widget.recurrence.amount.centsToString(),
        );
      }
    });

    _vm.update.addListener(_onUpdateListener);
    _templateFN.addListener(_onTemplateFnListener);
    _vm.listTemplates.addListener(_onListTemplatesListener);
    _vm.listTemplates.execute();
  }

  @override
  void dispose() {
    _descriptionEC.dispose();
    _amountEC.dispose();
    _templateEC.dispose();
    _templateFN.dispose();
    _formKey.currentState?.dispose();
    _intervalDaysEC.dispose();
    _dayOfMonthEC.dispose();
    super.dispose();
  }

  void _onUpdateListener() {
    _vm.update.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.update.error) {
      context.showMessage(title: context.words.errorUpdateRecurrence, type: MessageType.error, position: .top);
      _vm.update.clearResult();
    } else if (_vm.update.completed) {
      context.showMessage(title: context.words.recurrenceUpdated);
      _vm.update.clearResult();
      context.pop();
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _vm.update.execute(
      RecurrenceUpdateDto(
        id: widget.recurrence.id,
        description: _descriptionEC.text != widget.recurrence.description ? _descriptionEC.text : null,
        amount: _amountEC.text.toCents() != widget.recurrence.amount ? _amountEC.text.toCents() : null,
        customerId: _customer.id != widget.recurrence.customer.id ? _customer.id : null,
        templateId: _template?.id != widget.recurrence.template?.id ? _template?.id : null,
        startDate: _startDate != widget.recurrence.startDate ? _startDate : null,
        type: _type != widget.recurrence.type ? _type : null,
        frequency: _frequency != widget.recurrence.frequency ? _frequency : null,
        intervalDays: _frequency == Frequency.INTERVAL ? _intervalDays : null,
        dayOfMonth: _frequency == Frequency.MONTHLY ? _dayOfMonth : null,
        dayOfWeek: _frequency == Frequency.WEEKLY ? _dayOfWeek?.getInt() : null,
      ),
    );
  }

  void _onTemplateFnListener() {
    if (_templateFN.hasFocus) return;
    if (_template == null) {
      setState(() {
        _templateEC.clear();
      });
    }
  }

  final _listTemplatesListener = ValueNotifier(false);

  void _onListTemplatesListener() {
    _vm.listTemplates.running ? _listTemplatesListener.value = true : _listTemplatesListener.value = false;
    if (_vm.listTemplates.error) {
      context.showMessage(title: context.words.errorListTemplates, type: MessageType.error);
      _vm.listTemplates.clearResult();
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
                Text(context.words.editData, style: context.textTheme.largeBold, textAlign: .center),
                const SizedBox(height: 10),

                ValueListenableBuilder(
                  valueListenable: _listTemplatesListener,
                  builder: (context, value, child) {
                    return LoaderLocal(
                      isLoading: value,
                      child: child!,
                    );
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) => DropdownMenu<TemplateModel>(
                      width: constraints.maxWidth,
                      label: Text(context.words.templateRecurrence),
                      leadingIcon: _template == null
                          ? const Icon(Icons.search)
                          : Icon(
                              Icons.check_circle,
                              color: context.theme.colorScheme.primary,
                            ),
                      trailingIcon: _template == null
                          ? const Icon(Icons.arrow_drop_down)
                          : InkWell(
                              child: const Icon(Icons.clear),
                              onTap: () {
                                setState(() {
                                  _templateEC.clear();
                                  _template = null;
                                });
                              },
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
                          _type = value!.type;
                          _frequency = value.frequency;
                          if (_frequency == Frequency.INTERVAL) {
                            _intervalDays = value.intervalDays;
                            _intervalDaysEC.text = value.intervalDays.toString();
                          }
                          if (_frequency == Frequency.MONTHLY) {
                            _dayOfMonth = value.dayOfMonth;
                            _dayOfMonthEC.text = value.dayOfMonth.toString();
                          }
                          if (_frequency == Frequency.WEEKLY) {
                            _dayOfWeek = value.dayOfWeek != null ? FrequencyWeekly.fromInt(value.dayOfWeek!) : null;
                          }
                          // _descriptionEC.text = value.name;
                          _amountEC.text = CurrencyTextInputFormatter.simpleCurrency(locale: context.locale)
                              .formatString(
                                value.amount.centsToString(),
                              );
                        });
                      },

                      dropdownMenuEntries: _vm
                          .getTemplates(_type)
                          .map<DropdownMenuEntry<TemplateModel>>(
                            (x) => DropdownMenuEntry<TemplateModel>(value: x, label: x.name),
                          )
                          .toList(),
                    ),
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
                          title: Text(context.words.income, style: context.textTheme.small),
                          dense: true,
                          selected: _type == TransactionType.INCOME,
                          enabled: false,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<TransactionType>.adaptive(
                          value: TransactionType.EXPENSE,
                          title: Text(context.words.expense, style: context.textTheme.small),
                          dense: true,
                          selected: _type == TransactionType.EXPENSE,
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(_customer.name),
                  ),
                ),

                const SizedBox(height: 15),

                AppInputStack(
                  enabled: _template == null,
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
                        enabled: _template == null,
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
                        enabled: false,
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
                  builder: (context, constraints) => DropdownMenu<Frequency>(
                    enabled: _template == null,
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
                            enabled: _template == null,
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
                          if (_template != null) return;
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
                          if (_template != null) return;
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
                            enabled: _template == null,
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
                          if (_template != null) return;
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
