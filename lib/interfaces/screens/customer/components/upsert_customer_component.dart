import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/message_extension.dart';
import '../../../../core/extensions/validators_extension.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../../../domain/dtos/customer_upsert_dto.dart';
import '../../../../domain/enum/customer_type_enum.dart';
import '../../../../domain/models/customer_model.dart';
import '../../../core/app_gradient_button.dart';
import '../../../core/app_input.dart';
import '../../../core/app_input_stack.dart';
import '../customer_view_model.dart';
import '../lang/customer_localization_ext.dart';

class UpsertCustomerComponent extends StatefulWidget {
  const UpsertCustomerComponent({super.key, this.customer});

  final CustomerModel? customer;

  @override
  State<UpsertCustomerComponent> createState() => _UpsertCustomerComponentState();
}

class _UpsertCustomerComponentState extends State<UpsertCustomerComponent> with LoadingMixin {
  late final CustomerViewModel _vm;
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _documentEC = TextEditingController();
  final _phoneEC = TextEditingController();
  final _observationEC = TextEditingController();

  bool _isSupplier = false;
  bool _isCustomer = true;

  @override
  void initState() {
    _vm = context.read<CustomerViewModel>();

    if (widget.customer != null) {
      _nameEC.text = widget.customer!.name;
      _documentEC.text = widget.customer!.document ?? '';
      _phoneEC.text = widget.customer!.phone ?? '';
      _observationEC.text = widget.customer!.observation ?? '';

      final type = widget.customer!.type;
      _isSupplier = type == CustomerType.SUPPLIER || type == CustomerType.BOTH;
      _isCustomer = type == CustomerType.CUSTOMER || type == CustomerType.BOTH;
    }

    _vm.createCustomer.addListener(_onCreateListener);
    _vm.updateCustomer.addListener(_onUpdateListener);
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _vm.createCustomer.removeListener(_onCreateListener);
    _vm.updateCustomer.removeListener(_onUpdateListener);
    super.dispose();
  }

  void _onCreateListener() {
    _vm.createCustomer.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.createCustomer.error) {
      context.showMessage(title: context.words.errorCreateCustomer, type: MessageType.error, position: .top);
      _vm.createCustomer.clearResult();
    } else if (_vm.createCustomer.completed) {
      context.showMessage(title: context.words.customerCreated);
      _vm.createCustomer.clearResult();
      context.pop();
    }
  }

  void _onUpdateListener() {
    _vm.updateCustomer.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.updateCustomer.error) {
      context.showMessage(
        title: context.words.errorUpdateCustomer,
        type: MessageType.error,
      );
      _vm.updateCustomer.clearResult();
    } else if (_vm.updateCustomer.completed) {
      context.showMessage(title: context.words.customerUpdated);
      _vm.updateCustomer.clearResult();
      context.pop();
    }
  }

  CustomerType _getSelectedType() {
    if (_isSupplier && _isCustomer) return CustomerType.BOTH;
    if (_isSupplier) return CustomerType.SUPPLIER;
    return CustomerType.CUSTOMER;
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final type = _getSelectedType();

    if (widget.customer == null) {
      _vm.createCustomer.execute(
        CustomerCreateDto(
          name: _nameEC.text,
          document: _documentEC.text.isEmpty ? null : _documentEC.text,
          phone: _phoneEC.text.isEmpty ? null : _phoneEC.text,
          observation: _observationEC.text.isEmpty ? null : _observationEC.text,
          type: type,
        ),
      );
    } else {
      _vm.updateCustomer.execute(
        CustomerUpdateDto(
          id: widget.customer!.id,
          name: _nameEC.text != widget.customer!.name ? _nameEC.text : null,
          document: _documentEC.text != widget.customer!.document ? _documentEC.text : null,
          phone: _phoneEC.text != widget.customer!.phone ? _phoneEC.text : null,
          observation: _observationEC.text != widget.customer!.observation ? _observationEC.text : null,
          type: type != widget.customer!.type ? type : null,
        ),
      );
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
                  widget.customer == null ? context.words.newData : context.words.editData,
                  style: context.textTheme.largeBold,
                  textAlign: .center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: .spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      child: CheckboxListTile(
                        value: _isCustomer,
                        onChanged: (v) => setState(() {
                          _isCustomer = v ?? false;
                          if (!_isCustomer) _isSupplier = true;
                        }),
                        title: Text(context.words.customer, textAlign: .left),
                        controlAffinity: .leading,
                        contentPadding: .zero,
                        dense: true,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: CheckboxListTile(
                        value: _isSupplier,
                        onChanged: (v) => setState(() {
                          _isSupplier = v ?? false;
                          if (!_isSupplier) _isCustomer = true;
                        }),
                        title: Text(
                          context.words.supplier,
                          textAlign: .left,
                        ),
                        controlAffinity: .leading,
                        contentPadding: .zero,
                        dense: true,
                      ),
                    ),
                  ],
                ),
                AppInput(
                  label: context.words.name,
                  controller: _nameEC,
                  validator: (v) => v.validateRequired(context),
                  inputAction: .next,
                  icon: Icons.person,
                ),
                AppInput(
                  label: context.words.document,
                  controller: _documentEC,
                  inputAction: .next,
                  inputType: .number,
                  icon: Icons.badge,
                ),

                AppInput(
                  label: context.words.phone,
                  controller: _phoneEC,
                  inputAction: .next,
                  inputType: .phone,
                  icon: Icons.phone,
                ),
                AppInput(
                  label: context.words.observation,
                  controller: _observationEC,
                  inputAction: .done,
                  icon: Icons.note,
                  lines: 3,
                ),

                const SizedBox(height: 10),
                AppGradientButton(
                  label: context.words.save,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
