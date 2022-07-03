import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:kt_dart/collection.dart';
import 'package:note_app_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:note_app_ddd/domain/notes/value_objects.dart';
import 'package:note_app_ddd/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:provider/provider.dart';
import 'package:note_app_ddd/presentation/notes/note_form/misc/build_context_x.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 1700),
              backgroundColor: Colors.black,
              content: Text(
                "Want longer lists? Activate premium now!",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, child) {
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
            items: context.formTodos.asList(),
            shrinkWrap: true,
            updateDuration: const Duration(milliseconds: 50),
            removeDuration: const Duration(milliseconds: 250),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            onReorderFinished: (item, from, to, newItems) {
              context.formTodos = newItems.toImmutableList();
              context
                  .read<NoteFormBloc>()
                  .add(NoteFormEvent.todosChanged(context.formTodos));
            },
            itemBuilder: (context, itemAnimation, item, index) {
              return Reorderable(
                key: ValueKey(item.id),
                builder: (context, dragAnimation, inDrag) {
                  final elevation = lerpDouble(0, 8, dragAnimation.value);
                  return ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 0.95)
                        .animate(dragAnimation),
                    child: TodoTile(
                      // We have to pass in the index and not a complete TodoItemPrimitive to always get the most fresh value held in FormTodos
                      index: index,
                      elevation: elevation,
                    ),
                  );
                },
              );
            },
            // updateItemBuilder: (context, itemAnimation, item) {
            //   return Reorderable(
            //     key: ValueKey(item.id),
            //     builder: (context, dragAnimation, inDrag) {
            //       return TodoTile(
            //         index: index,
            //         item:item,
            //       );
            //     },
            //   );
            // },
            // removeItemBuilder: (context, itemAnimation, item) {
            //   return Reorderable(
            //     key: ValueKey(item.id),
            //     builder: (context, dragAnimation, inDrag) {
            //       return FadeTransition(
            //         opacity: itemAnimation,
            //         child: StaticTodoTile(
            //           todo: item,
            //         ),
            //       );
            //     },
            //   );
            // },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;
  final double? elevation;

  const TodoTile({required this.index, Key? key, double? elevation})
      : elevation = elevation ?? 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo = context.formTodos.getOrElse(
      index,
      (_) => TodoItemPrimitive.empty(),
    );

    final textEditingController = useTextEditingController(text: todo.name);

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),
        // A motion is a widget used to control how the pane animates.
        motion: const BehindMotion(),

        // A pane can dismiss the Slidable.
        // dismissible: DismissiblePane(onDismissed: () {}),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              context.formTodos = context.formTodos.minusElement(todo);
              context
                  .read<NoteFormBloc>()
                  .add(NoteFormEvent.todosChanged(context.formTodos));
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        child: Material(
          elevation: elevation!.toDouble(),
          borderRadius: BorderRadius.circular(8),
          animationDuration: const Duration(milliseconds: 50),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Checkbox(
                onChanged: (value) {
                  context.formTodos = context.formTodos.map(
                    (listTodo) => listTodo == todo
                        ? todo.copyWith(done: value ?? false)
                        : listTodo,
                  );
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
                value: todo.done,
              ),
              trailing: const Handle(
                child: Icon(Icons.list),
              ),
              title: TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: "Todo",
                  border: InputBorder.none,
                  counterText: '',
                ),
                maxLength: TodoName.maxLength,
                onChanged: (value) {
                  context.formTodos = context.formTodos.map(
                    (listTodo) => listTodo == todo
                        ? todo.copyWith(name: value)
                        : listTodo,
                  );
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
                validator: (_) {
                  return context
                      .read<NoteFormBloc>()
                      .state
                      .note
                      .todos
                      .value
                      .fold(
                        // Failure stemming from the TodoList length should NOT be displayed by the individual TextFormFields
                        (f) => null,
                        (todoList) => todoList[index].name.value.fold(
                            (f) => f.maybeMap(
                                  orElse: () => null,
                                  empty: (_) => "Cannot be empty",
                                  exceedingLength: (_) => "Too long",
                                  multiline: (_) => "Has to be in single line",
                                ),
                            (_) => null),
                      );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
