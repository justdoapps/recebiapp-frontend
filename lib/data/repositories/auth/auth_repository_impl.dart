import 'package:logging/logging.dart';

import '../../../core/mixins/http_request_mixin.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../../domain/enum/monetization_enum.dart';
import '../../../domain/models/user_model.dart';
import '../../services/http_service.dart';
import '../../services/preferences_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository with HttpRequestMixin {
  final HttpService _http;
  final PreferencesService _localData;

  AuthRepositoryImpl({
    required HttpService http,
    required PreferencesService localData,
  }) : _http = http,
       _localData = localData {
    _localData.onUserChanged.listen((newUser) {
      if (newUser != _user) {
        _user = newUser;
        notifyListeners();
      }
    });
  }

  UserModel? _user;

  final _log = Logger('AuthRepositoryImpl');

  @override
  UserModel? get user => _user?.copyWith(token: '');

  @override
  bool get isAuthenticated => user != null;

  @override
  Future<void> initAuth() async {
    final result = await _localData.getUser();

    result.fold(
      (error) => _log.severe('Falha ao buscar user no SharedPreferences', error),
      (value) {
        _user = value;
        if (value != null) {
          _refreshToken();
        }
        notifyListeners();
      },
    );
  }

  @override
  Future<void> updatePremium({required MonetizationPlan plan, required DateTime currentPeriodEnd}) async {
    _user = _user?.copyWith(plan: plan, currentPeriodEnd: currentPeriodEnd);
    _saveUserLocal(_user);
  }

  Future<void> _saveUserLocal(UserModel? u) async {
    final result = await _localData.saveUser(u);
    result.fold(
      (error) => _log.severe('Falha ao salvar user no SharedPreferences', error),
      (_) => {},
    );
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    // if (kDebugMode) {
    //   await Future.delayed(const Duration(seconds: 2));
    //   if (email == 'erro@erro.br') {
    //     return Result.error(AuthFailure(message: 'Credenciais inválidas'));
    //   }
    //   _user = UserModel(
    //     name: 'user debugMode',
    //     email: 'debug@debug.com',
    //     token: 'token debugMode',
    //     id: 'id debugMode',
    //   );
    //   _saveUserLocal(_user);
    //   return const Result.ok(null);
    // }

    final result = await safeRequest(
      request: () => _http.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      ),
    );

    return result.fold((error) => Result.error(error), (value) {
      if (value.statusCode == 401) {
        return Result.error(AuthFailure(message: 'Credenciais inválidas'));
      }

      if (value.statusCode != 200) {
        return Result.error(
          AuthFailure(
            message: 'Erro ao autenticar, tente novamente mais tarde',
          ),
        );
      }
      _user = UserModel.fromMap(value.data);
      _saveUserLocal(_user);

      return const Result.ok(null);
    });
  }

  @override
  Future<void> logout() async {
    _user = null;
    notifyListeners();

    (await _localData.saveUser(null)).fold(
      (error) => _log.warning('Failed to clear stored auth token', error),
      (_) => {},
    );
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await safeRequest(
      request: () => _http.post(
        '/auth/register',
        data: {'email': email, 'password': password, 'name': name},
      ),
    );

    return result.fold((error) => Result.error(error), (value) {
      if (value.statusCode != 201) {
        return Result.error(AuthFailure(message: 'Erro ao registrar'));
      }

      return const Result.ok(null);
    });
  }

  Future<void> _refreshToken() async {
    final result = await safeRequest(
      request: () => _http.post('/auth/refresh'),
    );

    result.fold((error) => Result.error(error), (value) {
      if (value.statusCode != 200) {
        return Result.error(AuthFailure(message: 'Erro ao renovar token'));
      }

      _user = _user?.copyWith(token: value.data['token']);
      _saveUserLocal(_user);

      return const Result.ok(null);
    });
  }
}
