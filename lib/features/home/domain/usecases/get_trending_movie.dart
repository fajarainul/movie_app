import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/repositories/trending_movie_repository.dart';

class GetTrendingMovie{
  GetTrendingMovie(this.repository);

  final TrendingMovieRepository repository;

  Future<Either<Failure, Movie>> execute({
    @required String? timeWindow
  }) async {
    return await repository.getTrendingMovie(timeWindow);
  }
}