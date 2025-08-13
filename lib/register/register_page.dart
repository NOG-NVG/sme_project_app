import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sme_project_app/register/register_form.dart';
import 'package:sme_project_app/register/register_form_cubit.dart';
import 'package:sme_project_app/repository/authentication_repository.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Create account")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocProvider<RegisterFormCubit>(
          create: (_) =>
              RegisterFormCubit(context.read<AuthenticationRepository>()),
          child: const RegisterForm(),
        ),
      ));
}