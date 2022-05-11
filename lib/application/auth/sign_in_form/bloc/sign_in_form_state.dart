part of 'sign_in_form_bloc.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState.initial(
      {@required
          required EmailAddress emailAddress,
      @required
          required Password password,
      @required
          required bool isSubmitting,
      @required
          required bool showErrorMessage,
      @required
          required Option<Either<AuthFailure, Unit>>
              authFailureOrSuccessOption}) = _Initial;
}
