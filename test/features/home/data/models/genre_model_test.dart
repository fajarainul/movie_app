import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/home/data/models/genre_model.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){

  final tGenreModel = GenreModel(
    name : 'comedy',
    id : 1
  );

  test(
    "should extends Genre entity",
    () async {
      //arrange
      
      //act
      
      //assert
      expect(tGenreModel, isA<Genre>());
      
    },
  );

  group('fromJson', (){

    test(
      "should return valid GenreModel from JSON",
      () async {
        //arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('genre.json'));
        //act
        final result = GenreModel.fromJson(jsonMap);
        
        //assert
        expect(result, tGenreModel);
        
      },
    );

  });

  group('toJson', (){
    test(
      "should return Json map with proper data",
      () async {
        //arrange
        
        //act
        final result = tGenreModel.toJson();

        //assert
        final expectedMap = json.decode(fixture('genre.json'));
        expect(result, expectedMap);
        
      },
    );
  });

}