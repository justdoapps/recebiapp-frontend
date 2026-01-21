sealed class Failure implements Exception {
  final String? message;

  Failure({this.message});
}

class DioFailure extends Failure {
  DioFailure({super.message});
}

class StatusCodeFailure extends Failure {
  StatusCodeFailure({super.message});
}

class GenericFailure extends Failure {
  GenericFailure({super.message});
}

class AuthFailure extends Failure {
  AuthFailure({super.message});
}
