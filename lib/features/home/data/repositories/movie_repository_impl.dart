// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:movie_app/core/errors/exceptions.dart';

import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/features/home/data/datasources/movie_local_datasource.dart';
import 'package:movie_app/features/home/data/datasources/movie_remote_datasource.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieRemoteDatasource remoteDatasource;
  final MovieLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Movie>>> getTrendingMovies(
      String? timeWindow) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResult =
            await remoteDatasource.getTrendingMovies(timeWindow);
        await localDatasource.cacheTrendingMovies(remoteResult);
        final listMovie = convertListMovieModelToListMovie(remoteResult);
        return Right(listMovie);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localResult =
            await localDatasource.getTrendingMoviesFromLocalDatasource();
        return Right(convertListMovieModelToListMovie(localResult));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  convertListMovieModelToListMovie(List<MovieModel> listMovieModel) {
    final List<Movie> listMovie = [];

    for (var movieModel in listMovieModel) {
      listMovie.add(movieModel.toMovie());
    }

    return listMovie;
  }
}
