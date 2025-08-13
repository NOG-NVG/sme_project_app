abstract class AddMovieFormState {}

class AddMovieFormInitial extends AddMovieFormState {}

class AddMovieFormSubmitting extends AddMovieFormState {}

class AddMovieFormSuccess extends AddMovieFormState {}

class AddMovieFormFailure extends AddMovieFormState {
  final String error;

  AddMovieFormFailure({required this.error});
}
