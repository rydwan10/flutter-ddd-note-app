import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:note_app_ddd/domain/notes/i_note_repository.dart';
import 'package:note_app_ddd/domain/notes/note.dart';
import 'package:note_app_ddd/domain/notes/note_failure.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@Injectable()
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const _Initial()) {
    on<NoteActorEvent>((event, emit) async {
      if (event is _Deleted) {
        emit(const NoteActorState.actionInProgress());
        final possibleFailure = await _noteRepository.delete(event.note);
        emit(
          possibleFailure.fold((l) => NoteActorState.deleteFailure(l),
              (_) => const NoteActorState.deleteSuccess()),
        );
      }
    });
  }
}
