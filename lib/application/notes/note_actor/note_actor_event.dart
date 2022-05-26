part of 'note_actor_bloc.dart';

@freezed
class NoteActorEvent with _$NoteActorEvent {
  const factory NoteActorEvent.started() = _Started;
  const factory NoteActorEvent.deleted(Note note) = _Deleted;
}