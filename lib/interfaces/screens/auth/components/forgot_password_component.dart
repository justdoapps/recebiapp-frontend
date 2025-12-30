import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/validators_extension.dart';
import '../../../core/app_gradient_button.dart';
import '../../../core/app_input.dart';
import '../lang/auth_localization_ext.dart';

class ForgotPasswordComponent extends StatefulWidget {
  const ForgotPasswordComponent({super.key});

  @override
  State<ForgotPasswordComponent> createState() =>
      _ForgotPasswordComponentState();
}

class _ForgotPasswordComponentState extends State<ForgotPasswordComponent> {
  final _emailEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        spacing: 10,
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        children: [
          const SizedBox(height: 30),
          Text(
            context.words.recoverPassword,
            style: context.textTheme.mediumBold,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const .symmetric(horizontal: 25),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: AppInput(
                    label: context.words.email,
                    icon: Icons.email,
                    controller: _emailEC,
                    inputType: .emailAddress,
                    requestFocus: true,
                    inputAction: .done,
                    validator: (value) =>
                        value.validateRequired(context) ??
                        value.validateEmail(context),
                  ),
                ),
                const SizedBox(height: 20),
                AppGradientButton(
                  onPressed: () {},
                  label: context.words.sendRecoverLink,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        context.words.back,
                        style: context.textTheme.mediumBold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
