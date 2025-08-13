
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app_cubit.dart';
import 'app/app_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sme_project_app/repository/authentication_repository.dart';


import 'login/login_page.dart';
import 'movies/movies_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(MyApp(authenticationRepository: authenticationRepository));
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const MyApp(
      {super.key, required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => RepositoryProvider.value(
    value: _authenticationRepository,
    child: BlocProvider<AppCubit>(
      create: (_) =>
          AppCubit(authenticationRepository: _authenticationRepository),
      child: const MyHomePage(),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          Navigator.of(context).pushReplacement(MoviesPage.route());
        } else {
          Navigator.of(context).pushReplacement(LoginPage.route());
        }
      },
      child: const Center(child: CircularProgressIndicator()),
    ),
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
  );
}