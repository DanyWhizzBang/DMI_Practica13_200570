import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dmi_practica11_200070/common/Constants.dart';
import 'package:dmi_practica11_200070/model/Media.dart';
import 'package:dmi_practica11_200070/model/cast.dart';

class HttpHandler {
  static final _httpHandler = HttpHandler();
  final String _baseUrl = "api.themoviedb.org";
  final String _lenguaje = "es-MX";

  static HttpHandler get(){
    return _httpHandler;
  }

  Future<dynamic> getJson(Uri uri) async {
    http.Response response = await http.get(uri);
    return json.decode(response.body);
  }

 
Future<List<Media>> fetchMovies({String category = "populares"}) async {
  var uri = new Uri.https(
    _baseUrl,
    "3/movie/$category",
    {
      'api_key': API_KEY,
      'page': "1",
      'language': _lenguaje,
    },
  );

  return getJson(uri).then((data) {
    if (category == "upcoming") {
      var sortedResults = data['results']
          .where((item) => item['release_date'] != null)
          .toList()
            ..sort((a, b) {
              DateTime dateA = DateTime.parse(a['release_date']);
              DateTime dateB = DateTime.parse(b['release_date']);
              return dateB.compareTo(dateA);
            });

      return sortedResults
          .map<Media>((item) => new Media(item, MediaType.movie))
          .toList();
    } else {
      return data['results']
          .map<Media>((item) => new Media(item, MediaType.movie))
          .toList();
    }
  });
}

  Future<List<Media>> fetchShow({String category = "populares"}) async {
    var uri = Uri.https(_baseUrl, "3/tv/$category",
        {'api_key': API_KEY, 
        'page': "1", 
        'language': _lenguaje});

    return getJson(uri).then(
        ((data) => data['results'].map<Media>((item) => Media(item, MediaType.show)).toList()));
  }
  
  Future<List<Media>> fetchCreditShows( int mediaId)  async {
    var uri = new Uri.https(_baseUrl, "3/tv/$mediaId/credits", {
      'api_key': API_KEY,
      'page': "1",
      'language': _lenguaje
    }); 
    return getJson(uri).then(((data) => data['cast']
        .map<Cast>((item) => new Cast(item, MediaType.show))
        .toList()));
  }
}
