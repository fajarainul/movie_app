import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

abstract class MovieLocalDatasource{
  ///get list trending [MovieModel] from local data source
  ///occured when user has no connection internet
  ///
  ///Throws [CacheException] when error occured
  Future<List<MovieModel>> getTrendingMoviesFromLocalDatasource();

  ///store list trending [Movie] into local data source
  Future<void> cacheTrendingMovies(List<MovieModel> listMovieModel);
}