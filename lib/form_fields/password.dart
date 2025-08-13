import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  static final _passwordRegex =
  RegExp(r'^[A-Za-z]{8,}');

  const Password.pure() : super.pure('');

  const Password.dirty(super.value) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    return _passwordRegex.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;
  }
}