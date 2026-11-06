sealed class Failure {
  const Failure({required this.message});

  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}

class AccessCodeFailure extends Failure {
  const AccessCodeFailure({required super.message});
}
