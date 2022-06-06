import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:note_app_ddd/presentation/sign_in/sign_in_page.dart';
import 'package:note_app_ddd/presentation/splash/splash_page.dart';

import '../notes/notes_overview/notes_overview_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage),
    MaterialRoute(page: NotesOveriewPage),
  ],
)
class AppRouter extends _$AppRouter {}
