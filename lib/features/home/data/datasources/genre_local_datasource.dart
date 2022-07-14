import 'package:movie_app/features/home/data/models/genre_model.dart';

abstract class GenreLocalDatasource{

  /// return list of [GenreModel] from local datasource
  Future<List<GenreModel>> getGenresFromLocalDatasource();

  ///save list of [GenreModel] to local datasource
  Future<void> cachedGenres(List<GenreModel> cachedGenres);

}