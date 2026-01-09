import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/dialog_extension.dart';
import 'auth_view_model.dart';
import 'components/forgot_password_component.dart';
import 'components/login_component.dart';
import 'components/register_component.dart';
import 'lang/auth_localization_ext.dart';
import 'widgets/logo_container_widget.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoContainerWidget(title: context.words.appName),
            const SizedBox(height: 30),
            const LoginComponent(),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                context.showBottomSheet(
                  child: Padding(
                    padding: .only(bottom: context.viewInsetsBottom),
                    child: Provider.value(
                      value: context.read<AuthViewModel>(),
                      child: const ForgotPasswordComponent(),
                    ),
                  ),
                );
              },
              child: Text(
                context.words.forgotPassword,
                style: context.textTheme.medium,
              ),
            ),
            Row(
              spacing: 10,
              children: [
                Flexible(
                  child: Divider(
                    height: 5,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
                Text(context.words.or, style: context.textTheme.medium),
                Flexible(
                  child: Divider(
                    height: 5,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              constraints: const BoxConstraints(maxWidth: 350),
              width: .infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  context.showBottomSheet(
                    child: Padding(
                      padding: .only(bottom: context.viewInsetsBottom),
                      child: Provider.value(
                        value: context.read<AuthViewModel>(),
                        child: const RegisterComponent(),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: context.theme.colorScheme.primary,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                ),
                child: Text(
                  context.words.createAccount,
                  style: context.textTheme.mediumBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
