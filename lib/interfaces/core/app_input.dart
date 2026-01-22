import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/build_context_extension.dart';

class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    required this.label,
    this.icon,
    this.obscure = false,
    required this.controller,
    this.validator,
    this.inputType,
    this.inputAction,
    this.onChanged,
    this.focusNode,
    this.onSubmitted,
    this.inputFormatters,
    this.requestFocus = false,
    this.lines,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
  });

  final String label;
  final IconData? icon;
  final bool obscure;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  final bool requestFocus;
  final List<TextInputFormatter>? inputFormatters;
  final int? lines;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLength;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool obscure = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    obscure = widget.obscure;
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.requestFocus) _focusNode.requestFocus();
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 67,
      child: TextFormField(
        maxLength: widget.maxLength,
        style: context.textTheme.verySmall,
        controller: widget.controller,
        obscureText: obscure,
        textAlign: .center,
        textAlignVertical: .center,
        autocorrect: false,
        keyboardType: widget.inputType,
        textInputAction: widget.inputAction,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        focusNode: _focusNode,
        inputFormatters: widget.inputFormatters,
        maxLines: widget.lines ?? 1,
        minLines: 1,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          errorStyle: context.textTheme.errorForm,
          contentPadding: const .symmetric(vertical: 5),
          labelText: widget.label,
          prefixIcon: Icon(
            widget.icon,
            color: context.theme.colorScheme.primary,
            size: 18,
          ),
          suffixIcon: Visibility(
            visible: widget.obscure,
            child: IconButton(
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              },
              icon: Icon(
                obscure ? Icons.visibility : Icons.visibility_off,
                color: context.theme.colorScheme.primary,
                size: 18,
              ),
            ),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
