import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:note_app_ddd/injection.dart';
import 'package:note_app_ddd/presentation/core/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureInjection(Environment.prod);
  runApp(AppWidget());
}
