import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:note_app_ddd/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_ddd/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:note_app_ddd/injection.dart';
import 'package:note_app_ddd/presentation/routes/router.dart';

import '../../../application/notes/note_actor/note_actor_bloc.dart';
import 'widgets/notes_overview_body_widget.dart';

class NotesOveriewPage extends StatelessWidget {
  const NotesOveriewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<NoteWatcherBloc>()
            ..add(
              const NoteWatcherEvent.watchAllStarted(),
            ),
        ),
        BlocProvider(create: (context) => getIt<NoteActorBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                  unauthenticated: (_) {
                    return AutoRouter.of(context).push(const SignInRoute());
                  },
                  orElse: () {});
            },
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
              listener: (context, state) {
            state.maybeMap(
                orElse: () {},
                deleteFailure: (state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 1700),
                      backgroundColor: Colors.black,
                      content: Text(
                        state.noteFailure.map(
                          unexpected: (_) =>
                              "Unexpected error occured when deleting note",
                          insufficientPermission: (_) =>
                              "Insufficient permission",
                          unableToUpdate: (_) => "Unable to update",
                          unableToDelete: (_) => "Unable to delete",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                });
          })
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Notes"),
            leading: IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEvent.signedOut());
                },
                icon: const Icon(Icons.exit_to_app)),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.indeterminate_check_box),
              ),
            ],
          ),
          body: const NotesOverviewBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
