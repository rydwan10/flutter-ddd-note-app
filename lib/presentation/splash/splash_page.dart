import 'package:flutter/material.dart' hide Router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_ddd/application/auth/auth_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:note_app_ddd/presentation/routes/router.dart';
import 'package:note_app_ddd/presentation/sign_in/sign_in_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          authenticated: (_) =>
              AutoRouter.of(context).push(const SignInRoute()),
          unauthenticated: (_) =>
              AutoRouter.of(context).push(const SignInRoute()),
        );
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
