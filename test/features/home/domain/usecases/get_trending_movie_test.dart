import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/repositories/movie_repository.dart';
import 'package:movie_app/features/home/domain/usecases/get_trending_movies.dart';

class MockMovieRepository extends Mock implements MovieRepository{

}

void main(){

  late GetTrendingMovie usecase;
  late MockMovieRepository mockMovieRepository;

  setUp((){
    mockMovieRepository = MockMovieRepository();
    usecase = GetTrendingMovie(mockMovieRepository);
  });

  const tTimeWindow = "day";
  const tListMovie = [
      Movie(
      adult : false,
      backdropPath : "/p1F51Lvj3sMopG948F5HsBbl43C.jpg",
      genreIds : [],
      id : 616037,
      mediaType : "movie",
      title : "Thor: Love and Thunder",
      originalLanguage : "en",
      originalTitle : "Thor: Love and Thunder",
      overview : "After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the extinction of the gods, Thor enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane Foster, who now inexplicably wields Mjolnir as the Mighty Thor. Together they embark upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him before it’s too late.",
      popularity : 5473.405,
      posterPath : "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",
      releaseDate : "2022-07-06",
      video : false,
      voteAverage : 7.066,
      voteCount : 519
    )
  ];

  test(
      "should get trending movie based on time window from the repository",
      () async {
      //arrange
        when(() => mockMovieRepository.getTrendingMovies(tTimeWindow))
          .thenAnswer((_) async => Right(tListMovie));
      //act
        final result =  await usecase(Params(timeWindow: tTimeWindow));
      //assert
        expect(result, Right(tListMovie));
        verify(() => mockMovieRepository.getTrendingMovies(tTimeWindow)).called(1);
        verifyNoMoreInteractions(mockMovieRepository);
        
      },
    );
}