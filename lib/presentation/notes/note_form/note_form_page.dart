import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_ddd/application/notes/note_form/note_form_bloc.dart';

import 'package:note_app_ddd/domain/notes/note.dart';
import 'package:note_app_ddd/injection.dart';
import 'package:note_app_ddd/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:note_app_ddd/presentation/notes/note_form/widgets/add_todo_tile_widget.dart';
import 'package:note_app_ddd/presentation/notes/note_form/widgets/body_field_widget.dart';
import 'package:note_app_ddd/presentation/notes/note_form/widgets/color_field_widget.dart';
import 'package:note_app_ddd/presentation/notes/note_form/widgets/todo_list_widget.dart';
import 'package:note_app_ddd/presentation/routes/router.dart';
import 'package:provider/provider.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;
  const NoteFormPage({
    Key? key,
    this.editedNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(
          NoteFormEvent.initialized(
            optionOf(editedNote),
          ),
        ),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
          listenWhen: (previous, current) =>
              previous.saveFailureOrSuccessOption !=
              current.saveFailureOrSuccessOption,
          listener: (context, state) {
            state.saveFailureOrSuccessOption.fold(() {}, (either) {
              either.fold(
                (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 2000),
                      backgroundColor: Colors.black,
                      content: Text(
                        failure.map(
                          insufficientPermission: (_) =>
                              'Insufficient permissions ❌',
                          unableToUpdate: (_) =>
                              "Couldn't update the note. Was it deleted from another device?",
                          unexpected: (_) =>
                              'Unexpected error occured, please contact support.',
                          unableToDelete: (_) => "Unable to delete",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                (_) {
                  AutoRouter.of(context).popUntil(
                    (route) => route.settings.name == NotesOveriewRoute.name,
                  );
                },
              );
            });
          },
          buildWhen: (p, c) => p.isSaving != c.isSaving,
          builder: (context, state) {
            return Stack(
              children: [
                const NoteFormScaffold(),
                SavingInProgressOverlay(
                  isSaving: state.isSaving,
                )
              ],
            );
          }),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;

  const SavingInProgressOverlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isSaving = true;

    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 12,
              ),
              Text(
                "Saving...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NoteFormScaffold extends StatelessWidget {
  const NoteFormScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (previous, current) =>
              previous.isEditing != current.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? "Edit a note" : "Create a note");
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (previous, current) =>
            previous.showErrorMessage != current.showErrorMessage,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
            child: Form(
              autovalidateMode: state.showErrorMessage
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    BodyField(),
                    ColorField(),
                    TodoList(),
                    AddTodoTile(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
