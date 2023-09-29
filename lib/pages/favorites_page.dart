import 'package:flutter/material.dart';
import 'package:showcase/helpers/storage_helper.dart';
import 'package:showcase/models/movie.dart';
import 'package:showcase/services/tmdb_services.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TmdbService _tmdbService = TmdbService();
  List<Movie> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
  }

  _loadFavoriteMovies() async {
    final favoriteIds = await StorageHelper.getFavorites();
    final allMovies = await _tmdbService.getPopularMovies();
    _favoriteMovies = allMovies.where((movie) => favoriteIds.contains(movie.id)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
      ),
      body: ListView.builder(
        itemCount: _favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = _favoriteMovies[index];
          return ListTile(
            title: Text(movie.title),
            subtitle: Text(movie.overview),
            leading: Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}'),
          );
        },
      ),
    );
  }
}
