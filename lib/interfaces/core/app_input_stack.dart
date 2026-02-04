import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/build_context_extension.dart';

class AppInputStack extends StatefulWidget {
  const AppInputStack({
    super.key,
    required this.label,
    this.leftStack,
    this.rightStack,
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
    this.enabled = true,
  });

  final String label;
  final Widget? leftStack;
  final Widget? rightStack;
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
  final bool enabled;

  @override
  State<AppInputStack> createState() => _AppInputStackState();
}

class _AppInputStackState extends State<AppInputStack> {
  // bool obscure = false;
  // late FocusNode _focusNode;

  @override
  void initState() {
    // obscure = widget.obscure;
    // _focusNode = widget.focusNode ?? FocusNode();
    // if (widget.requestFocus) _focusNode.requestFocus();
    // _focusNode.addListener(() => setState(() {}));
    super.initState();
    if (widget.requestFocus && widget.focusNode != null) {
      widget.focusNode?.requestFocus();
    }
  }

  @override
  void dispose() {
    // _focusNode.dispose();
    // widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 67,
      child: Stack(
        alignment: .topCenter,
        children: [
          TextFormField(
            maxLength: widget.maxLength,
            style: context.textTheme.verySmall,
            controller: widget.controller,
            obscureText: widget.obscure,
            textAlign: .center,
            textAlignVertical: .center,
            autocorrect: false,
            enabled: widget.enabled,
            keyboardType: widget.inputType,
            textInputAction: widget.inputAction,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            focusNode: widget.focusNode,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.lines ?? 1,
            minLines: 1,
            onTap: widget.onTap,
            readOnly: widget.readOnly,
            decoration: InputDecoration(
              contentPadding: const .symmetric(vertical: 5),
              errorStyle: context.textTheme.errorForm,
              labelText: widget.label,
              prefixIcon: const SizedBox.shrink(),
              prefixIconConstraints: const BoxConstraints(minHeight: 48),
            ),
            validator: widget.validator,
          ),
          widget.leftStack != null
              ? Align(
                  alignment: .centerLeft,
                  child: Padding(
                    padding: const .only(left: 5),
                    child: widget.leftStack,
                  ),
                )
              : const SizedBox.shrink(),
          widget.rightStack != null
              ? Align(
                  alignment: .centerRight,
                  child: Padding(
                    padding: const .only(right: 5),
                    child: widget.rightStack,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
