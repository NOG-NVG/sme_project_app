import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../add_movie/add_movie.dart';
import '../login/login_page.dart';
import '../repository/movies_repository.dart';
import '../repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MoviesPage());
  }

  @override
  Widget build(BuildContext context) => RepositoryProvider(
    create: (_) => MoviesRepository(),
    child: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Movies home"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                try {
                  await context.read<AuthenticationRepository>().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginPage()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to log out: $e')),
                  );
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('movies')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final movies = snapshot.data?.docs ?? [];
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return ListTile(
                      leading: const Icon(Icons.movie),
                      title: Text(movie['title'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          try {
                            await context
                                .read<MoviesRepository>()
                                .deleteMovie(movie.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Filme "${movie['title']}" deletado com sucesso!'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro: $e')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(movie['title'] ?? 'Sem título'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'Categorias: ${movie['categories'] ?? 'Sem categorias'}'),
                                  Text(
                                      'Imagem do Filme: ${movie['image_url'] ?? 'Sem imagens'}'),
                                  Text(
                                      'Url do Trailer: ${movie['trailer_url'] ?? 'Sem URL de Trailer'}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: movies.length,
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMoviePage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    ),
  );
}
