import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/poster.model.dart';

class PosterRequest{
  dynamic response;
  String url = 'http://api.themoviedb.org/3/movie/popular?api_key=fcd4d048a69aa3be21b9b388805f5ab1';

  Future<Poster> getPosterPath() async{
    try {
      response = await http.get(Uri.parse('$url&poster_path'));
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

}