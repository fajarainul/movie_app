import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/utils/app_constant.dart';
import 'package:movie_app/features/home/data/datasources/movie_local_datasource.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late MovieLocalDatasourceImpl movieLocalDatasourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    movieLocalDatasourceImpl =
        MovieLocalDatasourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getTrendingMoviesFromLocalDatasource', () {
    List<Map<String, dynamic>> listMapMovieModel = [
      {
        "adult": false,
        "backdrop_path": "/p1F51Lvj3sMopG948F5HsBbl43C.jpg",
        "genre_ids": [28, 12, 14],
        "id": 616037,
        "media_type": "movie",
        "title": "Thor: Love and Thunder",
        "original_language": "en",
        "original_title": "Thor: Love and Thunder",
        "overview":
            "After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the extinction of the gods, Thor enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane Foster, who now inexplicably wields Mjolnir as the Mighty Thor. Together they embark upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him before it’s too late.",
        "popularity": 4414.917,
        "poster_path": "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",
        "release_date": "2022-07-06",
        "video": false,
        "vote_average": 6.907,
        "vote_count": 639
      }
    ];

    List<MovieModel> tListMovieModel =
        listMapMovieModel.map<MovieModel>((item) {
      return MovieModel.fromJson(item);
    }).toList();

    test(
      "should return MovieModel from SharedPreferences when present in SharedPreferences",
      () async {
        //arrange
        when(() => mockSharedPreferences.getString(any()))
            .thenReturn(fixture('local_trending_movies.json'));
        //act
        final result = await movieLocalDatasourceImpl
            .getTrendingMoviesFromLocalDatasource();

        //assert
        verify(() => mockSharedPreferences
            .getString(AppConstant.KEY_CACHED_TRENDING_MOVIES));
        expect(result, equals(tListMovieModel));
      },
    );
  });
}
