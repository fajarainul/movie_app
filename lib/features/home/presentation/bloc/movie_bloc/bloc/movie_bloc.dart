import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/usecases/get_trending_movies.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetTrendingMovies getTrendingMovies;

  MovieBloc({required this.getTrendingMovies}) : super(MovieInitial()) {
    on<GetTrendingMoviesEvent>((event, emit) {});
  }
}
