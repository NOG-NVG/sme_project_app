import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../form_fields/password.dart';

import '../form_fields/email.dart';

class LoginFormState extends Equatable {
  final Email email;
  final Password password;
  final FormzStatus status;
  final String errorMessage;

  const LoginFormState(
      {this.email = const Email.pure(),
        this.password = const Password.pure(),
        this.status = FormzStatus.pure,
        this.errorMessage = ''});

  @override
  List<Object?> get props => [email, password, status];

  List<FormzInput> get inputs => [email, password];

  LoginFormState copyWith(
      {Email? email,
        Password? password,
        FormzStatus? status,
        String? errorMessage}) =>
      LoginFormState(
          email: email ?? this.email,
          password: password ?? this.password,
          status: status ?? this.status,
          errorMessage: errorMessage ?? this.errorMessage);
}
