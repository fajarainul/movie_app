import 'dart:convert';

import 'package:movie_app/core/errors/exceptions.dart';
import 'package:movie_app/core/utils/api_constant.dart';
import 'package:movie_app/features/home/data/models/genre_model.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/features/home/data/models/genre_response_model.dart';

abstract class GenreRemoteDatasource {
  /// return list of [GenreModel] from remote datasource
  Future<List<GenreModel>> getGenres();
}

class GenreRemoteDatasourceImpl implements GenreRemoteDatasource {
  final http.Client client;

  GenreRemoteDatasourceImpl({required this.client});

  @override
  Future<List<GenreModel>> getGenres() async {
    final response = await client.get(
      Uri.parse('${ApiConstant.baseApiUrl}/genre/movie/list')
          .replace(queryParameters: {
        'api_key': ApiConstant.apiKey,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final genreResponseModel =
          GenreResponseModel.fromJson(json.decode(response.body));
      return Future.value(genreResponseModel.genres);
    } else {
      throw ServerException();
    }
  }
}
