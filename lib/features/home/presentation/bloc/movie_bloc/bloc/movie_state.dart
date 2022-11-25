part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class EmptyTrendingMovies extends MovieState {}

class LoadingTrendingMovies extends MovieState{}

class LoadedTrendingMovies extends MovieState {
  final List<Movie> trendingMovies;

  const LoadedTrendingMovies({required this.trendingMovies});

  @override
  List<Object> get props => [trendingMovies];
}

class ErrorTrendingMovies extends MovieState {
  final String message;

  const ErrorTrendingMovies({required this.message});

  @override
  List<Object> get props => [message];
}
