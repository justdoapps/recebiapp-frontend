import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../../../domain/enum/transaction_enum.dart';
import '../../../../domain/models/customer_model.dart';
import '../../../../domain/models/transaction_model.dart';
import '../home_view_model.dart';

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

  CustomerModel? _customer;
  DateTime? _dueDate;
  TransactionType _type = TransactionType.INCOME;

  @override
  void initState() {
    _vm = context.read<HomeViewModel>();

    if (widget.transaction != null) {
      _descriptionEC.text = widget.transaction!.description;
      _amountEC.text = widget.transaction!.amount.centsToString(context.locale);
      _internalNoteEC.text = widget.transaction!.internalNote ?? '';
      _customerNoteEC.text = widget.transaction!.customerNote ?? '';
      _paymentInfoEC.text = widget.transaction!.paymentInfo ?? '';
      _customer = widget.transaction!.customer;
      _dueDate = widget.transaction!.dueDate;
      _type = widget.transaction!.type;
      _customer = widget.transaction!.customer;
      _dueDate = widget.transaction!.dueDate;
    }
    super.initState();
  }

  @override
  void dispose() {
    _descriptionEC.dispose();
    _amountEC.dispose();
    _internalNoteEC.dispose();
    _customerNoteEC.dispose();
    _paymentInfoEC.dispose();
    _formKey.currentState?.dispose();

    super.dispose();
  }

  void _onCreateListener() {}

  void _onUpdateListener() {}

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (widget.transaction == null) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.transaction == null ? 'Cadastrar Transação' : 'Editar Transação')),
      body: Center(),
    );
  }
}
