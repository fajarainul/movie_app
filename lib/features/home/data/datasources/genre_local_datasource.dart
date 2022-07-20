import 'dart:convert';

import 'package:movie_app/core/errors/exceptions.dart';
import 'package:movie_app/core/utils/app_constant.dart';
import 'package:movie_app/features/home/data/models/genre_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GenreLocalDatasource {
  /// return list of [GenreModel] from local datasource
  Future<List<GenreModel>> getGenresFromLocalDatasource();

  ///save list of [GenreModel] to local datasource
  Future<void> cachedGenres(List<GenreModel> cachedGenres);
}

class GenreLocalDatasourceImpl implements GenreLocalDatasource {
  final SharedPreferences sharedPreferences;

  GenreLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<List<GenreModel>> getGenresFromLocalDatasource() async {
    final jsonString =
        sharedPreferences.getString(AppConstant.KEY_CACHED_GENRES) ?? '';
    if (jsonString.isNotEmpty) {
      final List<Map<String, dynamic>> jsonMap =
          List<Map<String, dynamic>>.from(json.decode(jsonString));

      final List<GenreModel> result = jsonMap.map<GenreModel>((item) {
        return GenreModel.fromJson(item);
      }).toList();

      return Future.value(result);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachedGenres(List<GenreModel> cachedGenres) async {
    final jsonString = json.encode(cachedGenres);
    await sharedPreferences.setString(
        AppConstant.KEY_CACHED_GENRES, jsonString);
    return Future<void>.delayed(Duration.zero);
  }
}
