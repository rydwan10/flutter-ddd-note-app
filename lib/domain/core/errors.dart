import 'package:note_app_ddd/domain/core/failures.dart';

class NotAuthenticatedError extends Error {}

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    return Error.safeToString(
        'Encountered a ValueFailre at an unrecoverable point. Terminating... The Failure was: $valueFailure');
  }
}
