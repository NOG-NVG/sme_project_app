import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_movie_form_cubit.dart';

class AddMoviePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => AddMovieFormCubit(),
          child: AddMovieForm(),
        ),
      ),
    );
  }
}

class AddMovieForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _trailerUrlController = TextEditingController();
  final _categoriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a movie title';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _imageUrlController,
            decoration: InputDecoration(labelText: 'Image URL'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an image URL';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _trailerUrlController,
            decoration: InputDecoration(labelText: 'Trailer URL'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a trailer URL';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _categoriesController,
            decoration: InputDecoration(labelText: 'Categories (comma separated)'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter at least one category';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                BlocProvider.of<AddMovieFormCubit>(context).addMovie(
                  _titleController.text,
                  _imageUrlController.text,
                  _trailerUrlController.text,
                  _categoriesController.text.split(',').map((e) => e.trim()).toList(),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
