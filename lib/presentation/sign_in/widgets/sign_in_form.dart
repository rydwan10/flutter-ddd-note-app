import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_ddd/application/auth/auth_bloc.dart';
import 'package:note_app_ddd/application/auth/sign_in_form/bloc/sign_in_form_bloc.dart';
import 'package:note_app_ddd/presentation/routes/router.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () => {},
          (either) => {
            either.fold((failure) {
              String errMessage = "";
              failure.map(
                  cancelledByUser: (_) => errMessage = "Cancelled by user",
                  serverError: (_) => errMessage = "Server Error",
                  emailAlreadyInUse: (_) =>
                      errMessage = "Email address already in user",
                  invalidEmalAndPasswordCombination: (_) =>
                      "Invalid Email or Password combination");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 1700),
                  backgroundColor: Colors.black,
                  content: Text(
                    errMessage,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }, (_) {
              AutoRouter.of(context).replace(const NotesOveriewRoute());
              context
                  .read<AuthBloc>()
                  .add(const AuthEvent.authCheckRequested());
            })
          },
        );
      },
      builder: (context, state) {
        return Form(
          autovalidateMode: state.showErrorMessage
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              children: [
                const Text(
                  "📝",
                  style: TextStyle(
                    fontSize: 130,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email), labelText: "Email"),
                  autocorrect: false,
                  onChanged: (value) => context.read<SignInFormBloc>().add(
                        SignInFormEvent.emailChanged(value),
                      ),
                  validator: (_) => context
                      .read<SignInFormBloc>()
                      .state
                      .emailAddress
                      .value
                      .fold(
                          (l) => l.maybeMap(
                              invalidEmail: (_) => "Invalid Email",
                              orElse: () => null),
                          (r) => null),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email), labelText: "Password"),
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (value) => context.read<SignInFormBloc>().add(
                        SignInFormEvent.passwordChanged(value),
                      ),
                  validator: (_) => context
                      .read<SignInFormBloc>()
                      .state
                      .password
                      .value
                      .fold(
                          (l) => l.maybeMap(
                              shortPassword: (_) => "Short Password",
                              orElse: () => null),
                          (r) => null),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          context.read<SignInFormBloc>().add(
                                const SignInFormEvent
                                    .signInWithEmailAndPasswordPressed(),
                              );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          context.read<SignInFormBloc>().add(
                                const SignInFormEvent
                                    .registerWithEmailAndPassword(),
                              );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<SignInFormBloc>().add(
                          const SignInFormEvent.signInWithGooglePressed(),
                        );
                  },
                  child: const Text("Sign In with Google"),
                ),
                if (state.isSubmitting) ...[
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(value: null),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
