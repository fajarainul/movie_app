import 'package:movie_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/repositories/genre_repository.dart';

class GetGenres implements UseCase<List<Genre>, NoParams>{

  final GenreRepository repository;

  GetGenres(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams noParams) async{
    return await repository.getGenres();
  }

}