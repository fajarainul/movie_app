import 'package:dartz/dartz.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, Movie>> getTrendingMovie(String? timeWindow);
}
