import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/errors/exceptions.dart';
import 'package:movie_app/core/utils/api_constant.dart';
import 'package:movie_app/features/home/data/datasources/genre_remote_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/features/home/data/models/genre_response_model.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late GenreRemoteDatasourceImpl datasource;

  setUpAll(() {
    registerFallbackValue(MockUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = GenreRemoteDatasourceImpl(client: mockHttpClient);
  });

  final jsonString = fixture('genres.json');
  final tGenreResponseModel =
      GenreResponseModel.fromJson(json.decode(jsonString));
  final tListGenreModel = tGenreResponseModel.genres;

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((invocation) async => http.Response(
                jsonString, 200, headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
            }));
  }

  void setUpMockHttpClientFailed404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((invocation) async => http.Response(
                'Something went error', 404, headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
            }));
  }

  group('getGenres', () {
    test("should make a GET request with application/json header", () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      await datasource.getGenres();

      //assert
      verify(() => mockHttpClient.get(
            Uri.parse('${ApiConstant.baseApiUrl}/genre/movie/list')
                .replace(queryParameters: {
              'api_key': ApiConstant.apiKey,
            }),
            headers: {'Content-Type': 'application/json'},
          )).called(1);
    });

    test(
      "should return list GenreModel when response from remote datasource is 200",
      () async {
        //arrange
        setUpMockHttpClientSuccess200();

        //act
        final result = await datasource.getGenres();

        //assert
        expect(result, tListGenreModel);
      },
    );

    test(
      "should throw ServerException when response from remote datasource is 404",
      () async {
        //arrange
        setUpMockHttpClientFailed404();
        //act
        final call = datasource.getGenres;

        //assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
