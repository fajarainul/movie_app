import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/errors/exceptions.dart';
import 'package:movie_app/core/utils/app_constant.dart';
import 'package:movie_app/features/home/data/datasources/genre_local_datasource.dart';
import 'package:movie_app/features/home/data/models/genre_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferenfes extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferenfes mockSharedPreferenfes;
  late GenreLocalDatasourceImpl datasource;

  setUp(() {
    mockSharedPreferenfes = MockSharedPreferenfes();
    datasource =
        GenreLocalDatasourceImpl(sharedPreferences: mockSharedPreferenfes);
  });

  final tListGenreModel = [GenreModel(id: 1, name: 'test')];

  group('getGenresFromLocalDatasource', () {
    final jsonString = fixture('local_genres.json');
    test(
      "should return list GenreModel when cached data is exists",
      () async {
        //arrange
        when(() => mockSharedPreferenfes.getString(any()))
            .thenReturn(jsonString);
        //act
        final result = await datasource.getGenresFromLocalDatasource();

        //assert
        verify(() =>
                mockSharedPreferenfes.getString(AppConstant.KEY_CACHED_GENRES))
            .called(1);
        expect(result, tListGenreModel);
      },
    );

    test(
      "should throw CachedException when there is no data cached",
      () async {
        //arrange
        when(() => mockSharedPreferenfes.getString(any()))
            .thenThrow(CacheException());

        //act
        final call = datasource.getGenresFromLocalDatasource;

        //assert
        verifyZeroInteractions(mockSharedPreferenfes);
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cachedGenres', () {
    test(
      "should call sharedPReferences setString method",
      () async {
        //arrange
        when(() => mockSharedPreferenfes.setString(any(), any()))
            .thenAnswer((invocation) async => Future.value(false));
        final jsonString = json.encode(tListGenreModel);
        //act
        final result = datasource.cachedGenres(tListGenreModel);
        //assert
        verify(() => mockSharedPreferenfes.setString(
            AppConstant.KEY_CACHED_GENRES, jsonString)).called(1);
      },
    );
  });
}
