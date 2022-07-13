// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/repositories/movie_repository.dart';

class GetTrendingMovie implements UseCase<Movie, Params> {
  GetTrendingMovie(this.repository);

  final MovieRepository repository;

  @override
  Future<Either<Failure, Movie>> call(Params params) async {
    return await repository.getTrendingMovie(params.timeWindow);
  }
}

class Params extends Equatable {
  String timeWindow;
  Params({
    required this.timeWindow,
  }) : super();

  @override
  // TODO: implement props
  List<Object?> get props => [timeWindow];
}
