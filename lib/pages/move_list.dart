import 'package:flutter/material.dart';
import 'package:showcase/helpers/storage_helper.dart';
import 'package:showcase/models/movie.dart';
import 'package:showcase/services/tmdb_services.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<StatefulWidget> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final TmdbService _tmdbService = TmdbService();
  List<int> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  _loadFavorites() async {
    _favorites = await StorageHelper.getFavorites();
    setState(() {});
  }

  _toggleFavorite(Movie movie) {
    if (_favorites.contains(movie.id)) {
      _favorites.remove(movie.id);
    } else {
      _favorites.add(movie.id);
    }
    StorageHelper.saveFavorites(_favorites);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _tmdbService.getPopularMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final movie = snapshot.data![index];
              final isFavorite = _favorites.contains(movie.id);
              return ListTile(
                title: Text(movie.title),
                subtitle: Text(movie.overview),
                leading: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                trailing: IconButton(
                  icon:
                      Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () => _toggleFavorite(movie),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
