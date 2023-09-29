import 'package:flutter/material.dart';
import 'package:showcase/helpers/storage_helper.dart';
import 'package:showcase/models/movie.dart';
import 'package:showcase/services/tmdb_services.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final TmdbService _tmdbService = TmdbService();
  List<int> _favorites = [];
  int _page = 1;
  ScrollController _scrollController = ScrollController();
  List<Movie> _movies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchMovies();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMovies();
      }
    });
  }

  _loadFavorites() async {
    _favorites = await StorageHelper.getFavorites();
    setState(() {});
  }

  _fetchMovies() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      List<Movie> newMovies = await _tmdbService.getPopularMovies(page: _page);
      setState(() {
        _movies.addAll(newMovies);
        _page++;
        _isLoading = false;
      });
    }
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
    return ListView.builder(
      controller: _scrollController,
      itemCount: _movies.length + 1,
      itemBuilder: (context, index) {
        if (index == _movies.length) {
          return _isLoading
              ? Center(child: CircularProgressIndicator())
              : SizedBox();
        }
        final movie = _movies[index];
        final isFavorite = _favorites.contains(movie.id);
        return ListTile(
          title: Text(movie.title),
          subtitle: Text(movie.overview),
          leading: Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
          trailing: IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => _toggleFavorite(movie),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
