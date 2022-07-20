import 'dart:convert';

import 'package:movie_app/core/errors/exceptions.dart';
import 'package:movie_app/core/utils/api_constant.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/data/models/movie_response_model.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:http/http.dart' as http;

abstract class MovieRemoteDatasource {
  ///get list of trending [MovieModel] from remote data sources
  ///
  ///Throws [ServerException] if an error occured from server
  Future<List<MovieModel>> getTrendingMovies(String? timeWindow);
}

class MovieRemoteDatasourceImpl implements MovieRemoteDatasource {
  final http.Client client;

  MovieRemoteDatasourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getTrendingMovies(String? timeWindow) async {
    final response = await client.get(
      Uri.parse('${ApiConstant.baseApiUrl}/trending/all/$timeWindow')
          .replace(queryParameters: {
        'api_key': ApiConstant.apiKey,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final movieResponseModel =
          MovieResponseModel.fromJson(json.decode(response.body));

      return Future.value(movieResponseModel.results);
    }

    throw ServerException();
  }
}
