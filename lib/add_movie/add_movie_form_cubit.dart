import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_movie_form_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMovieFormCubit extends Cubit<AddMovieFormState> {
  AddMovieFormCubit() : super(AddMovieFormInitial());

  void addMovie(String title, String imageUrl, String trailerUrl, List<String> categories) async {
    emit(AddMovieFormSubmitting());
    try {
      await FirebaseFirestore.instance.collection('movies').add({
        'title': title,
        'image_url': imageUrl,
        'trailer_url': trailerUrl,
        'categories': categories,
        'created_at': DateTime.now(),
      });
      emit(AddMovieFormSuccess());
    } catch (e) {
      emit(AddMovieFormFailure(error: e.toString()));
    }
  }
}
