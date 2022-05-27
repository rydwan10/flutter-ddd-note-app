import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:note_app_ddd/domain/notes/i_note_repository.dart';
import 'package:note_app_ddd/domain/notes/note.dart';
import 'package:note_app_ddd/domain/notes/note_failure.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@Injectable()
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  NoteWatcherBloc(this._noteRepository) : super(_Initial()) {
    on<NoteWatcherEvent>((event, emit) async {
      if (event is _WatchAllStarted) {
        emit(const NoteWatcherState.loadInProgress());
        await _noteStreamSubscription?.cancel();
        _noteStreamSubscription = _noteRepository.watchAll().listen(
            (failureOrNotes) =>
                add(NoteWatcherEvent.notesReceived(failureOrNotes)));
      }

      if (event is _WatchUncompletedStarted) {
        emit(const NoteWatcherState.loadInProgress());
        await _noteStreamSubscription?.cancel();
        _noteStreamSubscription = _noteRepository.watchUncompleted().listen(
            (failureOrNotes) =>
                add(NoteWatcherEvent.notesReceived(failureOrNotes)));
      }

      if (event is _NotesReceived) {
        emit(event.failureOrNotes.fold((l) => NoteWatcherState.loadFailure(l),
            (r) => NoteWatcherState.loadSuccess(r)));
      }
    });
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}

// return emit.forEach(_noteRepository.watchAll(),
        //     onData: (Either<NoteFailure, KtList<Note>> eventRes) {
        //   return eventRes.fold((l) => NoteWatcherState.loadFailure(l),
        //       (r) => NoteWatcherState.loadSuccess(r));

        // });