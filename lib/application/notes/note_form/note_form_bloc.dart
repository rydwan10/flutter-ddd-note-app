import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:note_app_ddd/domain/notes/i_note_repository.dart';
import 'package:note_app_ddd/domain/notes/note.dart';
import 'package:note_app_ddd/domain/notes/note_failure.dart';
import 'package:note_app_ddd/domain/notes/value_objects.dart';
import 'package:note_app_ddd/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

@Injectable()
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<NoteFormEvent>((event, emit) async {
      if (event is _Initialized) {
        emit(
          event.initialNoteOption.fold(
            () => state,
            (initial) => state.copyWith(
              note: initial,
              isEditing: true,
            ),
          ),
        );
      }

      if (event is _BodyChanged) {
        emit(
          state.copyWith(
            note: state.note.copyWith(body: NoteBody(event.bodyStr)),
            saveFailureOrSuccessOption: none(),
          ),
        );
      }

      if (event is _ColorChanged) {
        emit(
          state.copyWith(
            note: state.note.copyWith(color: NoteColor(event.color)),
            saveFailureOrSuccessOption: none(),
          ),
        );
      }

      if (event is _TodosChanged) {
        emit(
          state.copyWith(
            note: state.note.copyWith(
              todos: List3(
                event.todos.map(
                  (primitive) => primitive.toDomain(),
                ),
              ),
            ),
            saveFailureOrSuccessOption: none(),
          ),
        );
      }

      if (event is _Saved) {
        Either<NoteFailure, Unit>? failureOrSuccess;

        emit(state.copyWith(
          isSaving: true,
          saveFailureOrSuccessOption: none(),
        ));

        if (state.note.failureOption.isNone()) {
          failureOrSuccess = state.isEditing
              ? await _noteRepository.update(state.note)
              : await _noteRepository.create(state.note);
        }

        emit(
          state.copyWith(
            isSaving: false,
            showErrorMessage: true,
            saveFailureOrSuccessOption: optionOf(failureOrSuccess),
          ),
        );
      }
    });
  }
}
