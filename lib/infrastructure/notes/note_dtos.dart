import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_app_ddd/domain/core/value_objects.dart';
import 'package:note_app_ddd/domain/notes/note.dart';
import 'package:note_app_ddd/domain/notes/todo_item.dart';
import 'package:note_app_ddd/domain/notes/value_objects.dart';
import 'package:kt_dart/kt.dart';

part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@freezed
abstract class NoteDTO with _$NoteDTO {
  const NoteDTO._();

  const factory NoteDTO({
    @JsonKey(ignore: true) String? id,
    @required required String body,
    @required required int color,
    @required required List<TodoItemDTO> todos,
    @required @ServerTimeStampConverter() FieldValue? serverTimeStamp,
  }) = _NoteDTO;

  Note toDomain() {
    return Note(
      id: UniqueId.fromUniqueString(id.toString()),
      body: NoteBody(body),
      color: NoteColor(Color(color)),
      todos: List3(todos.map((e) => e.toDomain()).toImmutableList()),
    );
  }

  factory NoteDTO.fromDomain(Note note) {
    return NoteDTO(
        id: note.id.getOrCrash(),
        body: note.body.getOrCrash(),
        color: note.color.getOrCrash().value,
        todos: note.todos
            .getOrCrash()
            .map((todoItem) => TodoItemDTO.fromDomain(todoItem))
            .asList(),
        serverTimeStamp: FieldValue.serverTimestamp());
  }

  factory NoteDTO.fromSnapshot(DocumentSnapshot snap) =>
      NoteDTO.fromJson(snap.data() as Map<String, dynamic>)
          .copyWith(id: snap.id);

  factory NoteDTO.fromJson(Map<String, dynamic> json) =>
      _$NoteDTOFromJson(json);

  factory NoteDTO.fromFirestore(DocumentSnapshot doc) {
    return NoteDTO.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc["documentID"]);
  }
}

@freezed
abstract class TodoItemDTO implements _$TodoItemDTO {
  const TodoItemDTO._();

  const factory TodoItemDTO(
      {@required required String id,
      @required required String name,
      @required required bool done}) = _TodoItemDTO;

  factory TodoItemDTO.fromDomain(TodoItem todoItem) {
    return TodoItemDTO(
      id: todoItem.id.getOrCrash(),
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: UniqueId.fromUniqueString(id),
      name: TodoName(name),
      done: done,
    );
  }

  factory TodoItemDTO.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDTOFromJson(json);
}

class ServerTimeStampConverter implements JsonConverter<FieldValue?, Object> {
  const ServerTimeStampConverter();
  @override
  FieldValue fromJson(Object json) => FieldValue.serverTimestamp();

  @override
  Object toJson(FieldValue? fieldValue) => fieldValue!;
}
