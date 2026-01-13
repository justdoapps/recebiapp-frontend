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

class RegisterComponent extends StatefulWidget {
  const RegisterComponent({super.key});

  @override
  State<RegisterComponent> createState() => _RegisterComponentState();
}

class _RegisterComponentState extends State<RegisterComponent> with LoadingMixin {
  late final AuthViewModel vm;

  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _nameEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _confirmPasswordFN = FocusNode();

  @override
  void initState() {
    super.initState();
    vm = context.read<AuthViewModel>();
    vm.register.addListener(_onResultRegister);
    vm.login.addListener(_onResultLogin);
  }

  @override
  void dispose() {
    vm.register.removeListener(_onResultRegister);
    vm.login.removeListener(_onResultLogin);
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _onResultRegister() {
    vm.register.running || vm.login.running ? showGlobalLoader() : hideGlobalLoader();
    if (vm.register.error) {
      context.showMessage(
        title: context.words.registerFailed,
        actionLabel: context.words.tryAgain,
        onAction: () {
          vm.register.execute((
            email: _emailEC.text,
            password: _passwordEC.text,
            name: _nameEC.text,
          ));
        },
      );
      vm.register.clearResult();
    }

    if (vm.register.completed) {
      context.showMessage(title: context.words.registerSuccess);
      vm.login.execute((email: _emailEC.text, password: _passwordEC.text));
      vm.register.clearResult();
    }
  }

  void _onResultLogin() {
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
    return SafeArea(
      child: Column(
        spacing: 10,
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        children: [
          const SizedBox(height: 20),
          Text(
            context.words.createAccount,
            style: context.textTheme.mediumBold,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const .symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppInput(
                    label: context.words.name,
                    icon: Icons.person,
                    controller: _nameEC,
                    inputType: .name,
                    requestFocus: true,
                    inputAction: .next,
                    validator: (value) => value.validateRequired(context),
                  ),
                  const SizedBox(height: 15),
                  AppInput(
                    label: context.words.email,
                    icon: Icons.email,
                    controller: _emailEC,
                    inputType: .emailAddress,
                    inputAction: .next,
                    validator: (value) => value.validateRequired(context) ?? value.validateEmail(context),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: .spaceAround,
                    children: [
                      Flexible(
                        child: AppInput(
                          label: context.words.password,
                          icon: Icons.lock,
                          obscure: true,
                          controller: _passwordEC,
                          inputType: .visiblePassword,
                          inputAction: .next,
                          onSubmitted: (value) => _confirmPasswordFN.requestFocus(),
                          validator: (value) => value.validateRequired(context) ?? value.validateMinLength(context, 6),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                        child: AppInput(
                          label: context.words.confirmPassword,
                          icon: Icons.lock,
                          obscure: true,
                          controller: _confirmPasswordEC,
                          inputType: .visiblePassword,
                          inputAction: .done,
                          focusNode: _confirmPasswordFN,

                          validator: (value) =>
                              value.validateRequired(context) ?? value.validateMatch(context, _passwordEC.text),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: .infinity,
                    child: AppGradientButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          vm.register.execute((
                            email: _emailEC.text,
                            password: _passwordEC.text,
                            name: _nameEC.text,
                          ));
                        }
                      },
                      label: context.words.createAccount,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        context.words.alreadyHaveAccount,
                        style: context.textTheme.small,
                      ),
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text(
                          context.words.back,
                          style: context.textTheme.smallBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
