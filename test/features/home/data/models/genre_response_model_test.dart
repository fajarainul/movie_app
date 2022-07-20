import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/data/models/base_response_model.dart';
import 'package:movie_app/features/home/data/models/genre_model.dart';
import 'package:movie_app/features/home/data/models/genre_response_model.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tListGenreModel = [GenreModel(name: 'test', id: 1)];
  final tListGenre = [Genre(name: 'test', id: 1)];
  final tGenreResponeModel =
      GenreResponseModel(genres: [GenreModel(name: 'test', id: 1)]);

  group('GenreResponseModel', () {
    test(
      "should extends BaseResponseModel",
      () async {
        //arrange

        //act

        //assert
        expect(tGenreResponeModel, isA<BaseResponseModel>());
      },
    );

    group('toJson', () {
      test(
        "should return a valid json map with proper data",
        () async {
          //arrange

          //act
          final result = tGenreResponeModel.toJson();

          //assert
          final expectedMap = json.decode(fixture('genres.json'));
          expect(result, expectedMap);
        },
      );
    });

    group('fromJson', () {
      test(
        "should return a GenreResponseModel from valid json",
        () async {
          //arrange
          final jsonMap = json.decode(fixture('genres.json'));
          //act
          final result = GenreResponseModel.fromJson(jsonMap);
          //assert
          expect(result, tGenreResponeModel);
        },
      );

      test(
        "should return list ofGenreModel from GenreResponseModel created with fromJson",
        () async {
          //arrange
          final jsonMap = json.decode(fixture('genres.json'));
          final genreResponseModel = GenreResponseModel.fromJson(jsonMap);
          //act
          final result = genreResponseModel.genres;

          //assert
          expect(result, tListGenreModel);
        },
      );
    });
  });
}
