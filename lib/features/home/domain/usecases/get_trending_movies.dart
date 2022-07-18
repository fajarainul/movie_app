// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/repositories/movie_repository.dart';

class GetTrendingMovies implements UseCase<List<Movie>, Params> {
  GetTrendingMovies(this.repository);

  final MovieRepository repository;

  @override
  Future<Either<Failure, List<Movie>>> call(Params params) async {
    return await repository.getTrendingMovies(params.timeWindow);
  }
}

class Params extends Equatable {
  final String timeWindow;
  const Params({
    required this.timeWindow,
  }) : super();

  @override
  List<Object?> get props => [timeWindow];
}
