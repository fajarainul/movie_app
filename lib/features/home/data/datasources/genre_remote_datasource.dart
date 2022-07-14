import 'package:movie_app/features/home/data/models/genre_model.dart';

abstract class GenreRemoteDatasource{

/// return list of [GenreModel] from remote datasource
  Future<List<GenreModel>> getGenres();
}