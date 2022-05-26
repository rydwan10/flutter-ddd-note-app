import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_app_ddd/domain/core/failures.dart';
import 'package:note_app_ddd/domain/core/value_objects.dart';
import 'package:note_app_ddd/domain/notes/value_objects.dart';

part 'todo_item.freezed.dart';

@freezed
abstract class TodoItem implements _$TodoItem {
  const TodoItem._();

  const factory TodoItem({
    @required required UniqueId id,
    @required required TodoName name,
    @required required bool done,
  }) = _TodoItem;

  factory TodoItem.empty() => TodoItem(
        id: UniqueId(),
        name: TodoName(""),
        done: false,
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return name.value.fold((l) => some(l), (r) => none());
  }
}
