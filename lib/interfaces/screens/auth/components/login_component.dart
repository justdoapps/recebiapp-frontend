import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/message_extension.dart';
import '../../../../core/extensions/validators_extension.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/failure.dart';
import '../../../core/app_gradient_button.dart';
import '../../../core/app_input.dart';
import '../auth_view_model.dart';
import '../lang/auth_localization_ext.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({super.key});

  @override
  State<LoginComponent> createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> with LoadingMixin {
  late final AuthViewModel vm;

  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    vm = context.read<AuthViewModel>();
    vm.login.addListener(_onResult);
  }

  @override
  void dispose() {
    vm.login.removeListener(_onResult);
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _onResult() {
    vm.login.running ? showGlobalLoader() : hideGlobalLoader();
    if (vm.login.error) {
      vm.login.errorValue is AuthFailure
          ? context.showMessage(title: context.words.credentialsInvalid)
          : context.showMessage(
              title: context.words.loginFailed,
              message: context.words.loginServerFailed,
              actionLabel: context.words.tryAgain,
              onAction: () {
                vm.login.execute((
                  email: _emailEC.text,
                  password: _passwordEC.text,
                ));
              },
            );
      vm.login.clearResult();
    }

    if (vm.login.completed) {
      vm.login.clearResult();
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppInput(
              label: context.words.email,
              icon: Icons.email,
              controller: _emailEC,
              inputType: .emailAddress,
              inputAction: .next,
              validator: (value) =>
                  value.validateRequired(context) ??
                  value.validateEmail(context),
            ),
            const SizedBox(height: 15),
            AppInput(
              label: context.words.password,
              icon: Icons.lock,
              obscure: true,
              controller: _passwordEC,
              inputType: .visiblePassword,
              inputAction: .done,
              validator: (value) => value.validateRequired(context),
              onSubmitted: (_) {
                if (_formKey.currentState?.validate() ?? false) {
                  vm.login.execute((
                    email: _emailEC.text,
                    password: _passwordEC.text,
                  ));
                }
              },
            ),
            const SizedBox(height: 15),
            AppGradientButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  vm.login.execute((
                    email: _emailEC.text,
                    password: _passwordEC.text,
                  ));
                }
              },
              label: context.words.login,
            ),
          ],
        ),
      ),
    );
  }
}
