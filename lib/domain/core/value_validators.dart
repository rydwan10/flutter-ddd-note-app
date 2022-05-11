import 'package:dartz/dartz.dart';
import 'package:note_app_ddd/domain/auth/value_objects.dart';

import 'failures.dart';

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const regex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(regex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 6) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}
