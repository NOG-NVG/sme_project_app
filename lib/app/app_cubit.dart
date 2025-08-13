import 'dart:async';

import 'package:bloc/bloc.dart';

import '../models/user.dart';
import '../repository/authentication_repository.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  AppCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
        authenticationRepository.currentUser.isNotEmpty
            ? AppState.authenticated(authenticationRepository.currentUser)
            : const AppState.unauthenticated(),
      ) {
    _userSubscription = _authenticationRepository.user.listen(
          (user) {
           if(user == User.empty) {
             emit(const AppState.unauthenticated());
           } else {
             emit(AppState.authenticated(user));
           }

          }
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}