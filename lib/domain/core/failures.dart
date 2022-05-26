import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  // Email and Password
  const factory ValueFailure.invalidEmail({
    @required required T failedValue,
  }) = InvalidEmail<T>;

  const factory ValueFailure.shortPassword({
    @required required T failedValue,
  }) = ShortPassword<T>;

  // Notes
  const factory ValueFailure.exceedingLength({
    @required required T failedValue,
    @required required int max,
  }) = ExceedingLength<T>;

  const factory ValueFailure.empty({
    @required required T failedValue,
  }) = Empty<T>;

  const factory ValueFailure.multiline({
    @required required T failedValue,
  }) = Multiline<T>;

  const factory ValueFailure.listTooLong(
      {@required required T failedValue,
      @required required int max}) = ListTooLong<T>;
}
