import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

abstract class TrendingMovieRepository{
  Future<Either<Failure, Movie>> getTrendingMovie(String? timeWindow);
}