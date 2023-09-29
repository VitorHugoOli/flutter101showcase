import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:showcase/models/movie.dart';

class TmdbService {
  final String apiKey = '9071821d7863327f748b777d32b3aaa5';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies({int? page}) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/movie/popular?api_key=$apiKey${page != null ? '&page=$page' : ''}'));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var moviesJson = jsonData['results'] as List;
      return moviesJson.map((movieJson) => Movie.fromJson(movieJson)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
