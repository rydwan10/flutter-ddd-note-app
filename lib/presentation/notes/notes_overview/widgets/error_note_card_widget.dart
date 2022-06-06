import 'package:flutter/material.dart';

import 'package:note_app_ddd/domain/notes/note.dart';

class ErrorNoteCard extends StatelessWidget {
  final Note note;

  const ErrorNoteCard({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[400],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const Text(
            "Invalid note. Please contact your support",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Details: ",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          Text(
            note.failureOption.fold(() => '', (a) => a.toString()),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          )
        ]),
      ),
    );
  }
}
