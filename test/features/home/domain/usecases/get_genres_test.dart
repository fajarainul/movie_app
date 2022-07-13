import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/repositories/genre_repository.dart';
import 'package:movie_app/features/home/domain/usecases/get_genres.dart';

class MockGenreRepository extends Mock implements GenreRepository{

}

void main(){
  late MockGenreRepository mockGenreRepository;
  late GetGenres usecase;


  setUp((){
    mockGenreRepository = MockGenreRepository();
    usecase = GetGenres(mockGenreRepository);
  });

  final List<Genre> tListGenre = [
    const Genre(id: 1, name: 'Comedy')
  ];

  test(
    "should get genres from repository",
    () async {
    //arrange
    when(()=>mockGenreRepository.getGenres()).thenAnswer((_) async => Right(tListGenre));
      
    //act
    final result = await usecase(NoParams());
      
    //assert
    expect(result, Right(tListGenre));
    verify(() => mockGenreRepository.getGenres()).called(1);
    verifyNoMoreInteractions(mockGenreRepository);
      
      
    },
  );
}