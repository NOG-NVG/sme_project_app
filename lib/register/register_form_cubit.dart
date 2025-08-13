import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:sme_project_app/form_fields/confirmed_password.dart';
import 'package:sme_project_app/register/register_form_state.dart';

import '../form_fields/email.dart';
import '../form_fields/password.dart';
import '../repository/authentication_repository.dart';

class RegisterFormCubit extends Cubit<RegisterFormState> {
  final AuthenticationRepository _authenticationRepository;

  RegisterFormCubit(this._authenticationRepository)
      : super(const RegisterFormState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    List<FormzInput> inputs = [...state.inputs];
    inputs.remove(state.email);
    emit(state.copyWith(
        email: email, status: Formz.validate([...inputs, email])));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
        password: password.value, value: state.confirmedPassword.value);
    List<FormzInput> inputs = [...state.inputs];
    inputs.remove(state.password);
    inputs.remove(state.confirmedPassword);
    emit(state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        status: Formz.validate([...inputs, password, confirmedPassword])));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword =
    ConfirmedPassword.dirty(value: value, password: state.password.value);
    List<FormzInput> inputs = [...state.inputs];
    inputs.remove(state.confirmedPassword);
    emit(state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate([...inputs, confirmedPassword])));
  }

  Future<void> registerFormSubmit() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    _authenticationRepository
        .createUserWithEmailPassword(
        email: state.email.value, password: state.password.value)
        .then(
            (value) =>
            emit(state.copyWith(status: FormzStatus.submissionSuccess)),
        onError: (error) => emit(state.copyWith(
            errorMessage: error.toString(),
            status: FormzStatus.submissionFailure)));
  }
}