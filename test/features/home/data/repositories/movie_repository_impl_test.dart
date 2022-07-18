import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/errors/exceptions.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/features/home/data/datasources/movie_local_datasource.dart';
import 'package:movie_app/features/home/data/datasources/movie_remote_datasource.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

class MockMovieRemoteDatasource extends Mock implements MovieRemoteDatasource {}

class MockMovieLocalDatasource extends Mock implements MovieLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDatasource mockMovieRemoteDatasource;
  late MockMovieLocalDatasource mockMovieLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockMovieRemoteDatasource = MockMovieRemoteDatasource();
    mockMovieLocalDatasource = MockMovieLocalDatasource();
    repository = MovieRepositoryImpl(
      networkInfo: mockNetworkInfo,
      remoteDatasource: mockMovieRemoteDatasource,
      localDatasource: mockMovieLocalDatasource,
    );
  });

  String tTimeWindow = 'week';
  final tListMovieModel = [
    const MovieModel(
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
        popularity: 5473.405,
        posterPath: "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",
        releaseDate: "2022-07-06",
        video: false,
        voteAverage: 7.066,
        voteCount: 519)
  ];

  final tListMovie = [
    const Movie(
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
        popularity: 5473.405,
        posterPath: "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",
        releaseDate: "2022-07-06",
        video: false,
        voteAverage: 7.066,
        voteCount: 519)
  ];

  group('getTrendingMovies', () {
    test(
      "should check if device is online",
      () async {
        //arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() =>
                mockMovieLocalDatasource.cacheTrendingMovies(tListMovieModel))
            .thenAnswer((_) async => Future.value(false));
        when(() => mockMovieRemoteDatasource.getTrendingMovies(any()))
            .thenAnswer((_) async => tListMovieModel);
        //act
        repository.getTrendingMovies(tTimeWindow);
        //assert
        verify(() => mockNetworkInfo.isConnected).called(1);
      },
    );

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() =>
                mockMovieLocalDatasource.cacheTrendingMovies(tListMovieModel))
            .thenAnswer((_) async => Future.value(false));
      });

      test(
        "should return remote data when call to remote datasource is success",
        () async {
          //arrange
          when(() => mockMovieRemoteDatasource.getTrendingMovies(any()))
              .thenAnswer((_) async => tListMovieModel);
          //act
          final Either<Failure, List<Movie>> result =
              await repository.getTrendingMovies(tTimeWindow);
          //assert
          result.fold((l) => null, (listMovie) {
            verify(() =>
                    mockMovieRemoteDatasource.getTrendingMovies(tTimeWindow))
                .called(1);
            expect(listMovie, equals(tListMovie));
          });
        },
      );

      test(
        "should cache data locally when call to remote datasource is success",
        () async {
          //arrange
          when(() => mockMovieRemoteDatasource.getTrendingMovies(any()))
              .thenAnswer((_) async => tListMovieModel);
          //act
          final result = await repository.getTrendingMovies(tTimeWindow);
          //assert
          verify(() => mockMovieRemoteDatasource.getTrendingMovies(tTimeWindow))
              .called(1);
          verify(() =>
                  mockMovieLocalDatasource.cacheTrendingMovies(tListMovieModel))
              .called(1);
        },
      );

      test(
        "should throw server exception when call to remote data is unsuccessful",
        () async {
          //arrange
          when(() => mockMovieRemoteDatasource.getTrendingMovies(any()))
              .thenThrow(ServerException());
          //act
          final result = await repository.getTrendingMovies(tTimeWindow);

          //assert
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockMovieRemoteDatasource.getTrendingMovies(tTimeWindow))
              .called(1);
          verifyZeroInteractions(mockMovieLocalDatasource);
          expect(result, Left(ServerFailure()));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        "should return locally cached data when cached data is present",
        () async {
          //arrange
          when(() => mockMovieLocalDatasource
                  .getTrendingMoviesFromLocalDatasource())
              .thenAnswer((_) async => tListMovieModel);
          //act
          final result = await repository.getTrendingMovies(tTimeWindow);

          //assert
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockMovieLocalDatasource
              .getTrendingMoviesFromLocalDatasource()).called(1);
          verifyZeroInteractions(mockMovieRemoteDatasource);

          result.fold((l) => null, (listMovie) {
            expect(listMovie, tListMovie);
          });
        },
      );

      test(
        "should throw CacheException when cached data is not present",
        () async {
          //arrange
          when(() => mockMovieLocalDatasource
                  .getTrendingMoviesFromLocalDatasource())
              .thenThrow(CacheException());
          //act
          final result = await repository.getTrendingMovies(tTimeWindow);
          //assert
          verify(() => mockNetworkInfo.isConnected).called(1);
          verifyZeroInteractions(mockMovieRemoteDatasource);
          verify(() => mockMovieLocalDatasource
              .getTrendingMoviesFromLocalDatasource()).called(1);

          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
