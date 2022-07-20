import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/errors/exceptions.dart';
import 'package:movie_app/core/utils/api_constant.dart';
import 'package:movie_app/features/home/data/datasources/movie_remote_datasource.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/data/models/movie_response_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late MovieRemoteDatasourceImpl movieRemoteDataSourceImpl;

  setUpAll(() {
    registerFallbackValue(MockUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    movieRemoteDataSourceImpl =
        MovieRemoteDatasourceImpl(client: mockHttpClient);
  });

  String tTimeWindow = 'day';
  final jsonString = fixture('trending_movies_response.json');
  final tMovieResponseModel =
      MovieResponseModel.fromJson(json.decode(jsonString));
  final List<MovieModel> tListMovieModel = tMovieResponseModel.results!;

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((invocation) async => http.Response(
                jsonString.toString(), 200, headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
            }));
  }

  void setUpMockHttpClientFailed404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((invocation) async => http.Response(
                'Something went wrong', 404, headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
            }));
  }

  group('getTrendingMovies', () {
    test(
        "should perform a GET request with application/json header with params as a endpoint of url",
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      await movieRemoteDataSourceImpl.getTrendingMovies(tTimeWindow);

      //assert
      verify(() => mockHttpClient.get(
            Uri.parse('${ApiConstant.baseApiUrl}/trending/all/$tTimeWindow')
                .replace(queryParameters: {
              'api_key': ApiConstant.apiKey,
            }),
            headers: {'Content-Type': 'application/json'},
          ));
    });

    test(
      "should return List of MovieModel when status code from remote datasource is 200",
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        final result =
            await movieRemoteDataSourceImpl.getTrendingMovies(tTimeWindow);

        //assert
        expect(result, equals(tListMovieModel));
      },
    );

    test(
      "should throw ServerException when the response code is not 200",
      () async {
        //arrange
        setUpMockHttpClientFailed404();
        //act
        final call = movieRemoteDataSourceImpl.getTrendingMovies;

        //assert
        expect(() => call(tTimeWindow),
            throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
