import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

abstract class MovieRemoteDatasource{
  ///get list of trending [MovieModel] from remote data sources
  ///
  ///Throws [ServerException] if an error occured from server
  Future<List<MovieModel>> getTrendingMovies(String? timeWindow); 
}