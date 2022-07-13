import 'package:dartz/dartz.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';

abstract class GenreRepository {
  Future<Either<Failure, List<Genre>>> getGenres();
}
