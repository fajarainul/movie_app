import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/data/models/movie_response_model.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tMovieModel = MovieModel(
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
      voteCount: 100);

  const tMovie = Movie(
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
      voteCount: 100);

  group('fromJson', () {
    test(
      "should return a valid model from JSON",
      () async {
        //arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('movie.json'));
        //act
        final result = MovieModel.fromJson(jsonMap);
        //assert
        expect(result, tMovieModel);
      },
    );
  });

  group('toJson', () {
    test(
      "should return a JSON Map containing proper data",
      () async {
        //arrange

        //act
        final result = tMovieModel.toJson();
        //assert
        final expectedMap = json.decode(fixture('movie.json'));

        expect(result, expectedMap);
      },
    );
  });

  group('toMovie', () {
    test(
      "should return Movie instance",
      () async {
        //arrange

        //act
        final result = tMovieModel.toMovie();
        //assert
        expect(result, tMovie);
      },
    );
  });
}
