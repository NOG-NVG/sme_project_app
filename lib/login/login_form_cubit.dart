import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:sme_project_app/form_fields/password.dart';

import '../repository/authentication_repository.dart';
import '../form_fields/email.dart';
import 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  final AuthenticationRepository _authenticationRepository;

  LoginFormCubit(this._authenticationRepository)
      : super(const LoginFormState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    List<FormzInput> inputs = [...state.inputs];
    inputs.remove(state.email);
    emit(state.copyWith(
        email: email, status: Formz.validate([...inputs, email])));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    List<FormzInput> inputs = [...state.inputs];
    inputs.remove(state.password);
    emit(state.copyWith(
        password: password, status: Formz.validate([...inputs, password])));
  }

  Future<void> loginWithEmailPassword() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    _authenticationRepository
        .loginWithEmailPassword(
        email: state.email.value, password: state.password.value)
        .then(
            (value) =>
            emit(state.copyWith(status: FormzStatus.submissionSuccess)),
        onError: (error) => emit(state.copyWith(
            errorMessage: error.toString(),
            status: FormzStatus.submissionFailure)));
  }
}