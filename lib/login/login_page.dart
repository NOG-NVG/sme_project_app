import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sme_project_app/login/login_form.dart';
import 'package:sme_project_app/login/login_form_cubit.dart';

import '../repository/authentication_repository.dart';

class LoginPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Movies app")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocProvider<LoginFormCubit>(
          create: (_) =>
              LoginFormCubit(context.read<AuthenticationRepository>()),
          child: const LoginForm(),
        ),
      ));
}