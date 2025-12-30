import 'auth_keys_lang.dart';

abstract class AuthUsLang {
  static const words = <String, String>{
    AuthKeysLang.loginServerFailed:
        'An error occurred on the server while trying to log in to the app, please try again.',
    AuthKeysLang.loginFailed: 'Login failed',
    AuthKeysLang.forgotPassword: 'Forgot Password',
    AuthKeysLang.sendRecoverLink: 'Send recovery link to email',
    AuthKeysLang.createAccount: 'Create Account',
    AuthKeysLang.login: 'Login',
    AuthKeysLang.alreadyHaveAccount: 'Already have an account?',
    AuthKeysLang.credentialsInvalid: 'Credentials invalid',
    AuthKeysLang.recoverPassword: 'Recover Password',
    AuthKeysLang.registerSuccess: 'Account created successfully',
    AuthKeysLang.registerFailed: 'Failed to create account',
  };
}
