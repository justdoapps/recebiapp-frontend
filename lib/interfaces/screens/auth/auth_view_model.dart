import 'package:logging/logging.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/auth/auth_repository.dart';

typedef AuthLoginArgs = ({String email, String password});
typedef AuthRegisterArgs = ({String email, String password, String name});

class AuthViewModel {
  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    login = Command1<void, AuthLoginArgs>(_login);
    register = Command1<void, AuthRegisterArgs>(_register);
    forgotPassword = Command1<void, String>(_forgotPassword);
  }

  final AuthRepository _authRepository;
  final _log = Logger('AuthViewModel');

  late Command1<void, AuthLoginArgs> login;
  late Command1<void, AuthRegisterArgs> register;
  late Command1<void, String> forgotPassword;

  Future<Result<void>> _login(AuthLoginArgs credential) async {
    final result = await _authRepository.login(
      email: credential.email,
      password: credential.password,
    );
    if (result is Error<void>) {
      _log.warning('Login falhou: ${result.error}');
    }
    return result;
  }

  Future<Result<void>> _register(AuthRegisterArgs credential) async {
    final result = await _authRepository.register(
      email: credential.email,
      password: credential.password,
      name: credential.name,
    );
    if (result is Error<void>) {
      _log.warning('Register falhou: ${result.error}');
    }
    return result;
  }

  Future<Result<void>> _forgotPassword(String email) async {
    final result = await _authRepository.forgotPassword(email: email);
    if (result is Error<void>) {
      _log.warning('Forgot Password falhou: ${result.error}');
    }
    return result;
  }

  void dispose() {
    login.dispose();
    register.dispose();
    forgotPassword.dispose();
  }
}
