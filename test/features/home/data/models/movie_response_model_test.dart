import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/data/models/base_response_model.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/data/models/movie_response_model.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tMovieResponseModel =
      MovieResponseModel(page: 1, totalPages: 10, totalResults: 200, results: [
    MovieModel(
        adult: false,
        backdropPath: "/p1F51Lvj3sMopG948F5HsBbl43C.jpg",
        genreIds: [1],
        id: 616037,
        mediaType: "movie",
        title: "Thor: Love and Thunder",
        originalLanguage: "en",
        originalTitle: "Thor: Love and Thunder",
        overview:
            "After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the extinction of the gods, Thor enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane Foster, who now inexplicably wields Mjolnir as the Mighty Thor. Together they embark upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him before it’s too late.",
        popularity: 100.000,
        posterPath: "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",
        releaseDate: "2022-07-06",
        video: false,
        voteAverage: 5.6,
        voteCount: 100)
  ]);

  final tListMovieModel = tMovieResponseModel.results;

  final tListMovie = [
    Movie(
        adult: false,
        backdropPath: "/p1F51Lvj3sMopG948F5HsBbl43C.jpg",
        genreIds: [1],
        id: 616037,
        mediaType: "movie",
        title: "Thor: Love and Thunder",
        originalLanguage: "en",
        originalTitle: "Thor: Love and Thunder",
        overview:
            "After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the extinction of the gods, Thor enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane Foster, who now inexplicably wields Mjolnir as the Mighty Thor. Together they embark upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him before it’s too late.",
        popularity: 100.000,
        posterPath: "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",
        releaseDate: "2022-07-06",
        video: false,
        voteAverage: 5.6,
        voteCount: 100)
  ];

  group('MovieResponseModel', () {
    test(
      "should extends BaseResponseModel",
      () async {
        //arrange

        //act

        //assert
        expect(tMovieResponseModel, isA<BaseResponseModel>());
      },
    );

    group('toJson', () {
      test(
        "should return valid json map with proper data",
        () async {
          //arrange

          //act
          final result = tMovieResponseModel.toJson();

          //assert
          final expectedMap =
              json.decode(fixture('trending_movies_response.json'));
          expect(result, expectedMap);
        },
      );
    });

    group('fromJson', () {
      test(
        "should return valid MovieResponseModel instance from json",
        () async {
          //arrange
          final jsonMap = json.decode(fixture('trending_movies_response.json'));
          //act
          final result = MovieResponseModel.fromJson(jsonMap);

          //assert
          expect(result, tMovieResponseModel);
        },
      );

      test(
        "should return list of MovieModel when MovieResponseModel instance created from fromJson",
        () async {
          //arrange
          final jsonMap = json.decode(fixture('trending_movies_response.json'));
          final movieModelResponse = MovieResponseModel.fromJson(jsonMap);

          //act
          final result = movieModelResponse.results;
          //assert
          expect(result, tListMovieModel);
        },
      );
    });
  });
}
