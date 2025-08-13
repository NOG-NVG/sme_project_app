import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:sme_project_app/form_fields/confirmed_password.dart';
import '../form_fields/password.dart';
import '../form_fields/email.dart';

class RegisterFormState extends Equatable {
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final String? errorMessage;

  const RegisterFormState(
      {this.email = const Email.pure(),
        this.password = const Password.pure(),
        this.confirmedPassword = const ConfirmedPassword.pure(),
        this.status = FormzStatus.pure,
        this.errorMessage});

  @override
  List<Object?> get props => [email, password, confirmedPassword, status];

  List<FormzInput> get inputs => [email, password, confirmedPassword];

  RegisterFormState copyWith(
      {Email? email,
        Password? password,
        ConfirmedPassword? confirmedPassword,
        FormzStatus? status,
        String? errorMessage}) =>
      RegisterFormState(
          email: email ?? this.email,
          password: password ?? this.password,
          confirmedPassword: confirmedPassword ?? this.confirmedPassword,
          status: status ?? this.status,
          errorMessage: errorMessage ?? this.errorMessage);
}