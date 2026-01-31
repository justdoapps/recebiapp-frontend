import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../core/extensions/message_extension.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../../../domain/dtos/template_upsert_dto.dart';
import '../../../../domain/enum/frequency_enum.dart';
import '../../../../domain/enum/transaction_enum.dart';
import '../../../../domain/models/template_model.dart';
import '../../../core/app_gradient_button.dart';
import '../../../core/app_input_stack.dart';
import '../../customer/lang/customer_localization_ext.dart';
import '../../home/lang/home_localization_ext.dart';
import '../lang/template_localization_ext.dart';
import '../template_view_model.dart';

class UpsertTemplateComponent extends StatefulWidget {
  const UpsertTemplateComponent({super.key, this.template});

  final TemplateModel? template;

  @override
  State<UpsertTemplateComponent> createState() => _UpsertTemplateComponentState();
}

class _UpsertTemplateComponentState extends State<UpsertTemplateComponent> with LoadingMixin {
  late final TemplateViewModel _vm;
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _amountEC = TextEditingController();

  TransactionType _type = TransactionType.INCOME;
  Frequency _frequency = Frequency.INTERVAL;
  int? _intervalDays;
  int? _dayOfMonth;
  int? _dayOfWeek;

  @override
  void initState() {
    _vm = context.read<TemplateViewModel>();

    if (widget.template != null) {
      _nameEC.text = widget.template!.name;
      _amountEC.text = widget.template!.amount.toString();
      _type = widget.template!.type;
      _frequency = widget.template!.frequency;
      _intervalDays = widget.template!.intervalDays;
      _dayOfMonth = widget.template!.dayOfMonth;
      _dayOfWeek = widget.template!.dayOfWeek;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _amountEC.text = CurrencyTextInputFormatter.simpleCurrency(locale: context.locale).formatString(
            widget.template!.amount.centsToString(),
          );
        }
      });
    }

    _vm.create.addListener(_onCreateListener);
    _vm.update.addListener(_onUpdateListener);
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _vm.create.removeListener(_onCreateListener);
    _vm.update.removeListener(_onUpdateListener);
    super.dispose();
  }

  void _onCreateListener() {
    _vm.create.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.create.error) {
      context.showMessage(title: context.words.errorCreateTemplate, type: MessageType.error, position: .top);
      _vm.create.clearResult();
    } else if (_vm.create.completed) {
      context.showMessage(title: context.words.templateCreated);
      _vm.create.clearResult();
      context.pop();
    }
  }

  void _onUpdateListener() {
    _vm.update.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.update.error) {
      context.showMessage(
        title: context.words.errorUpdateTemplate,
        type: MessageType.error,
      );
      _vm.update.clearResult();
    } else if (_vm.update.completed) {
      context.showMessage(title: context.words.templateUpdated);
      _vm.update.clearResult();
      context.pop();
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (widget.template == null) {
      _vm.create.execute(
        TemplateCreateDto(
          name: _nameEC.text,
          amount: _amountEC.text.toCents(),
          type: _type,
          frequency: _frequency,
          intervalDays: _intervalDays,
          dayOfMonth: _dayOfMonth,
          dayOfWeek: _dayOfWeek,
        ),
      );
    } else {
      _vm.update.execute(
        TemplateUpdateDto(
          id: widget.template!.id,
          name: _nameEC.text != widget.template!.name ? _nameEC.text : null,
          amount: _amountEC.text.toCents() != widget.template!.amount ? _amountEC.text.toCents() : null,
          type: _type != widget.template!.type ? _type : null,
          frequency: _frequency != widget.template!.frequency ? _frequency : null,
          intervalDays: _intervalDays != widget.template!.intervalDays ? _intervalDays : null,
          dayOfMonth: _dayOfMonth != widget.template!.dayOfMonth ? _dayOfMonth : null,
          dayOfWeek: _dayOfWeek != widget.template!.dayOfWeek ? _dayOfWeek : null,
        ),
      );
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
                  widget.template == null ? context.words.newData : context.words.editData,
                  style: context.textTheme.largeBold,
                  textAlign: .center,
                ),
                const SizedBox(height: 10),

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
                  label: context.words.name,
                  controller: _nameEC,
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

                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) => DropdownMenu<Frequency>(
                          width: constraints.maxWidth,
                          label: Text(context.words.frequency),
                          leadingIcon: Icon(Icons.timer_outlined, color: context.theme.colorScheme.primary),
                          requestFocusOnTap: true,
                          initialSelection: _frequency,
                          textStyle: context.textTheme.small,
                          onSelected: (value) {
                            setState(() {
                              if (value != null) _frequency = value;
                            });
                          },

                          dropdownMenuEntries: Frequency.values
                              .map((x) => DropdownMenuEntry(value: x, label: x.getContextName(context)))
                              .toList(),
                        ),
                      ),
                    ),
                    if (_frequency == Frequency.INTERVAL) ...[
                      TextFormField(
                        controller: _intervalDaysEC,
                        decoration: InputDecoration(labelText: context.words.intervalDays),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.words.requiredField;
                          }
                          return null;
                        },
                      ),
                    ],
                    if (_frequency == Frequency.MONTHLY) ...[
                      TextFormField(
                        controller: _dayOfMonthEC,
                        decoration: InputDecoration(labelText: context.words.dayOfMonth),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.words.requiredField;
                          }
                          return null;
                        },
                      ),
                    ],
                    if (_frequency == Frequency.WEEKLY) ...[
                      TextFormField(
                        controller: _dayOfWeekEC,
                        decoration: InputDecoration(labelText: context.words.dayOfWeek),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.words.requiredField;
                          }
                          return null;
                        },
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
