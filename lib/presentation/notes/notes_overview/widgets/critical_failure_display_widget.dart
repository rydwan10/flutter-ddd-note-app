import 'package:flutter/material.dart';

import 'package:note_app_ddd/domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure failure;
  const CriticalFailureDisplay({
    Key? key,
    required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const Text(
        "😱",
        style: TextStyle(fontSize: 100),
      ),
      Text(
        failure.maybeMap(
          insufficientPermission: (_) => 'Insufficient permissions',
          orElse: () => 'Unexpected error.\nPlease, contact support.',
        ),
        style: const TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
      TextButton(
        onPressed: () {
          //print('Sending email...');
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(Icons.mail),
            SizedBox(width: 4),
            Text('Click here to sending report email'),
          ],
        ),
      ),
    ]));
  }
}
