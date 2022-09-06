import 'dart:convert';
import 'package:films/model/movies_and_series.model.dart';
import 'package:http/http.dart' as http;
import '../model/poster.model.dart';

class PosterRequest{
  dynamic response;
  String url = 'http://api.themoviedb.org';
  String key = 'fcd4d048a69aa3be21b9b388805f5ab1';

  Future<Poster> getPosterPath() async{
    try {
      response = await http.get(Uri.parse('$url/3/movie/popular?api_key=$key&poster_path'));
      if (response.statusCode == 200) {
        return Poster.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load album');
      }
    } on Exception catch(e){
      print('não foi possivel obter o poster path $e');
      rethrow;
    }
  }

  Future<MoviesAndSeriesModel> getSearchMoviesAndSeries(String query) async{
    try {
      response = await http.get(Uri.parse('$url/3/search/multi?api_key=$key&query=$query'));
      if (response.statusCode == 200) {
        return MoviesAndSeriesModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load album');
      }
    } on Exception catch(e){
      print('não foi possivel obter o fazer a pesquisa $e');
      rethrow;
    }
  }

}