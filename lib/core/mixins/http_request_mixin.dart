import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../utils/failure.dart';
import '../utils/result.dart';

mixin HttpRequestMixin {
  final _logger = Logger('HttpRequestMixin');

  Future<Result<T>> safeRequest<T>({
    required Future<T> Function() request,
    T Function(dynamic json)? parser,
  }) async {
    try {
      final response = await request();
      return parser != null ? Result.ok(parser(response)) : Result.ok(response);
    } on DioException catch (e, s) {
      _logger.severe('Erro na requisição HTTP: ${e.message}', e, s);
      return Result.error(DioFailure(message: e.message));
    } catch (e, s) {
      _logger.severe('Erro genérico na requisição: $e', e, s);
      return Result.error(GenericFailure(message: e.toString()));
    }
  }
}
