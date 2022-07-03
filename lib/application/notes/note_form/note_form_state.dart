part of 'note_form_bloc.dart';

@freezed
class NoteFormState with _$NoteFormState {
  const factory NoteFormState({
    @required required Note note,
    @required required bool showErrorMessage,
    @required required bool isSaving,
    @required required bool isEditing,
    @required
        required Option<Either<NoteFailure, Unit>> saveFailureOrSuccessOption,
  }) = _NoteFormState;

  factory NoteFormState.initial() => NoteFormState(
        note: Note.empty(),
        showErrorMessage: false,
        isEditing: false,
        isSaving: false,
        saveFailureOrSuccessOption: none(),
        // saveFailureOrSuccessOption: some(left(const NoteFailure.unableToUpdate())),
      );
}
