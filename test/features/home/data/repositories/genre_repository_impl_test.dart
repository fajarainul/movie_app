import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/errors/exceptions.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/features/home/data/datasources/genre_local_datasource.dart';
import 'package:movie_app/features/home/data/datasources/genre_remote_datasource.dart';
import 'package:movie_app/features/home/data/models/genre_model.dart';
import 'package:movie_app/features/home/data/repositories/genre_repository_impl.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockGenreRemoteDataSource extends Mock implements GenreRemoteDatasource {}

class MockGenreLocalDatasource extends Mock implements GenreLocalDatasource {}

void main() {
  late GenreRepositoryImpl repository;
  late MockNetworkInfo mockNetworkInfo;
  late MockGenreLocalDatasource mockGenreLocalDatasource;
  late MockGenreRemoteDataSource mockGenreRemoteDataSource;

  final tListGenreModel = [GenreModel(name: 'comedy', id: 1)];

  List<Genre> tListGenre = tListGenreModel;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockGenreLocalDatasource = MockGenreLocalDatasource();
    mockGenreRemoteDataSource = MockGenreRemoteDataSource();
    repository = GenreRepositoryImpl(
        networkInfo: mockNetworkInfo,
        localDatasource: mockGenreLocalDatasource,
        remoteDatasource: mockGenreRemoteDataSource);
  });

  group('getGenres', () {
    test(
      "should check if device is online",
      () async {
        //arrange
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((invocation) async => true);
        when(() => mockGenreRemoteDataSource.getGenres())
            .thenAnswer((_) async => tListGenreModel);
        when(() => mockGenreLocalDatasource.cachedGenres(tListGenreModel))
            .thenAnswer((invocation) async => Future.value());
        //act
        await repository.getGenres();

        //assert
        verify(() => mockNetworkInfo.isConnected).called(1);
      },
    );

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((invocation) async => true);
        when(() => mockGenreLocalDatasource.cachedGenres(tListGenreModel))
            .thenAnswer((invocation) async => Future.value());
      });

      test(
        "should return remote data when call to remote datasource is successful",
        () async {
          //arrange
          when(() => mockGenreRemoteDataSource.getGenres())
              .thenAnswer((_) async => tListGenreModel);
          //act
          final result = await repository.getGenres();
          //assert
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockGenreRemoteDataSource.getGenres()).called(1);

          expect(result, equals(Right(tListGenre)));
        },
      );

      test(
        "should cached to local data when call to remote data is successful",
        () async {
          //arrange
          when(() => mockGenreRemoteDataSource.getGenres())
              .thenAnswer((_) async => tListGenreModel);
          //act
          final result = await repository.getGenres();

          //assert
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockGenreRemoteDataSource.getGenres()).called(1);
          verify(() => mockGenreLocalDatasource.cachedGenres(tListGenreModel))
              .called(1);

          expect(result, Right(tListGenre));
        },
      );

      test(
        "should throw ServerException when call to remote data is unsuccessful",
        () async {
          //arrange
          when(() => mockGenreRemoteDataSource.getGenres())
              .thenThrow(ServerException());
          //act
          final result = await repository.getGenres();

          //assert
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockGenreRemoteDataSource.getGenres()).called(1);
          verifyZeroInteractions(mockGenreLocalDatasource);

          expect(result, Left(ServerFailure()));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((invocation) async => false);
      });

      test(
        "should return local data when list genre is exist in local datasource",
        () async {
          //arrange
          when(() => mockGenreLocalDatasource.getGenresFromLocalDatasource())
              .thenAnswer((_) async => tListGenreModel);
          //act
          final result = await repository.getGenres();

          //assert
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockGenreLocalDatasource.getGenresFromLocalDatasource())
              .called(1);
          verifyZeroInteractions(mockGenreRemoteDataSource);

          expect(result, Right(tListGenre));
        },
      );

      test(
        "should throw CacheException when list genre is not exist in local datasource",
        () async {
          //arrange
          when(() => mockGenreLocalDatasource.getGenresFromLocalDatasource())
              .thenThrow(CacheException());
          //act
          final result = await repository.getGenres();

          //assert
          verify(() => mockNetworkInfo.isConnected).called(1);
          verifyZeroInteractions(mockGenreRemoteDataSource);
          verify(() => mockGenreLocalDatasource.getGenresFromLocalDatasource())
              .called(1);

          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
