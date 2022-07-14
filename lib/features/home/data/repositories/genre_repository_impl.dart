// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:movie_app/core/errors/exceptions.dart';

import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/features/home/data/datasources/genre_local_datasource.dart';
import 'package:movie_app/features/home/data/datasources/genre_remote_datasource.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/repositories/genre_repository.dart';

class GenreRepositoryImpl extends GenreRepository {
  final NetworkInfo networkInfo;
  final GenreRemoteDatasource remoteDatasource;
  final GenreLocalDatasource localDatasource;

  GenreRepositoryImpl({
    required this.networkInfo,
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResult = await remoteDatasource.getGenres();
        localDatasource.cachedGenres(remoteResult);
        return Right(remoteResult);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localResult =
            await localDatasource.getGenresFromLocalDatasource();
        return Right(localResult);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
