import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'preferences_service.dart';

class AuthInterceptor extends Interceptor {
  final PreferencesService localData;

  AuthInterceptor(this.localData);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await localData.getUser();
    final log = Logger('AuthInterceptor');
    result.fold(
      (error) => log.severe('Falha ao buscar user no SharedPreferences', error),
      (value) {
        if (value != null) {
          options.headers['Authorization'] = 'Bearer ${value.token}';
        }
      },
    );

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == null) return handler.next(response);
    final code = response.statusCode!;
    // if (code < 200 || code > 299) return handler.next(response);

    if (code == 401) {
      await localData.saveUser(null);
      return handler.next(response);
    }

    return handler.next(response);
  }
}

class HttpService extends DioForNative {
  final PreferencesService _localData;

  HttpService(this._localData) {
    options = BaseOptions(
      baseUrl: kIsWeb
          ? 'http://localhost:3000/api/v1'
          : 'http://10.0.2.2:3000/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) => status != null && status < 500,
    );

    interceptors.add(AuthInterceptor(_localData));

    if (kDebugMode) {
      interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (Object obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }
}
