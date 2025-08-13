import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:sme_project_app/login/login_form_cubit.dart';
import 'package:sme_project_app/login/login_form_state.dart';
import '../movies/movies_page.dart';
import '../register/register_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocListener<LoginFormCubit, LoginFormState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage)));
          } else if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Login successful')));
          }
        },
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(
                    "https://cdn4.iconfinder.com/data/icons/google-i-o-2016/512/google_firebase-2-512.png"),
              ),
              const SizedBox(height: 16),
              _EmailInput(),
              const SizedBox(height: 8),
              _PasswordInput(),
              const SizedBox(height: 8),
              _LoginButton(),
              const SizedBox(height: 8),
              _SignUpButton()
            ])),
      );

}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LoginFormCubit, LoginFormState>(
          buildWhen: (previous, current) => previous.email != current.email,
          builder: (context, state) => TextFormField(
            key: const Key('login_form_email_key'),
            keyboardType: TextInputType.emailAddress,
            onChanged: (email) =>
                context.read<LoginFormCubit>().emailChanged(email),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Email',
                errorText: state.email.invalid ? 'Invalid email' : null),
          ));
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<LoginFormCubit,
      LoginFormState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) => TextFormField(
        key: const Key("login_form_password_key"),
        onChanged: (password) =>
            context.read<LoginFormCubit>().passwordChanged(password),
        obscureText: true,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Password',
            errorText: state.password.invalid ? 'Invalid password' : null),
      ));
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<LoginFormCubit, LoginFormState>(
    buildWhen: (previous, current) => previous.status != current.status,
    builder: (context, state) {
      if (state.status.isSubmissionSuccess) {
        // Navega para a MoviesPage se o login for bem-sucedido
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MoviesPage()),
          );
        });
      }

      return state.status.isSubmissionInProgress
          ? const CircularProgressIndicator()
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.green,
        ),
        onPressed: state.status.isValidated
            ? () => context.read<LoginFormCubit>().loginWithEmailPassword()
            : null,
        child: const Text('Login'),
      );
    },
  );
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TextButton(
    key: const Key('login_form_register_button'),
    onPressed: () => Navigator.of(context).push<void>(RegisterPage.route()),
    style: TextButton.styleFrom(backgroundColor: Colors.amberAccent),
    child: const Text('Create account'),
  );
}
