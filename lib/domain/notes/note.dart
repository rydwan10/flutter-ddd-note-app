import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:note_app_ddd/domain/core/failures.dart';
import 'package:note_app_ddd/domain/core/value_objects.dart';
import 'package:note_app_ddd/domain/notes/todo_item.dart';
import 'package:note_app_ddd/domain/notes/value_objects.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();

  const factory Note({
    @required required UniqueId id,
    @required required NoteBody body,
    @required required NoteColor color,
    @required required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(""),
        color: NoteColor(NoteColor.predefinedColors[0]),
        todos: List3(emptyList()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(
          todos
              .getOrCrash()
              .map((todoItem) => todoItem.failureOption)
              .filter((o) => o.isSome())
              .getOrElse(0, (_) => none())
              .fold(
                () => right(unit),
                (a) => left(a),
              ),
        )
        .fold((l) => some(l), (r) => none());
  }
}
