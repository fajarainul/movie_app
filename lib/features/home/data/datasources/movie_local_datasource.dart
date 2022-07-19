// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:movie_app/core/errors/exceptions.dart';
import 'package:movie_app/core/utils/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

abstract class MovieLocalDatasource {
  ///get list trending [MovieModel] from local data source
  ///occured when user has no connection internet
  ///
  ///Throws [CacheException] when error occured
  Future<List<MovieModel>> getTrendingMoviesFromLocalDatasource();

  ///store list trending [Movie] into local data source
  Future<void> cacheTrendingMovies(List<MovieModel> listMovieModel);
}

class MovieLocalDatasourceImpl implements MovieLocalDatasource {
  final SharedPreferences sharedPreferences;
  MovieLocalDatasourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<List<MovieModel>> getTrendingMoviesFromLocalDatasource() {
    final String jsonString =
        sharedPreferences.getString(AppConstant.KEY_CACHED_TRENDING_MOVIES) ??
            '';
    if (jsonString.isNotEmpty) {
      final List<Map<String, dynamic>> listMapMovieModel =
          List<Map<String, dynamic>>.from(json.decode(jsonString));

      List<MovieModel> listMovieModel =
          listMapMovieModel.map<MovieModel>((item) {
        return MovieModel.fromJson(item);
      }).toList();

      return Future.value(listMovieModel);
    } else {
      throw (CacheException());
    }
  }

  @override
  Future<void> cacheTrendingMovies(List<MovieModel> listMovieModel) async { 
    final jsonString = json.encode(listMovieModel);
    final result = await sharedPreferences.setString(
        AppConstant.KEY_CACHED_TRENDING_MOVIES, jsonString);

    return Future<void>.delayed(Duration.zero);
  }
}
