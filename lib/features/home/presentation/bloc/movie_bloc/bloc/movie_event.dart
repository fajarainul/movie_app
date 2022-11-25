part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class GetTrendingMoviesEvent extends MovieEvent {
  final String timeWindow;

  const GetTrendingMoviesEvent(this.timeWindow);

  @override
  List<Object> get props => [timeWindow];
}
