import 'auth_keys_lang.dart';

abstract class AuthPtLang {
  static const words = <String, String>{
    AuthKeysLang.loginServerFailed: 'Ocorreu um erro no servidor ao tentar entrar no app, tente novamente.',
    AuthKeysLang.loginFailed: 'Falha ao tentar fazer login',
    AuthKeysLang.forgotPassword: 'Esqueceu a senha?',
    AuthKeysLang.sendRecoverLink: 'Enviar link de recuperação para o email',
    AuthKeysLang.createAccount: 'Criar conta',
    AuthKeysLang.login: 'Login',
    AuthKeysLang.alreadyHaveAccount: 'Já tem uma conta?',
    AuthKeysLang.credentialsInvalid: 'Credenciais inválidas',
    AuthKeysLang.recoverPassword: 'Recuperar senha',
    AuthKeysLang.registerSuccess: 'Conta criada com sucesso',
    AuthKeysLang.registerFailed: 'Falha ao criar conta',
  };
}
