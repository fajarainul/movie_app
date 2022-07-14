import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/network/network_info.dart';

class MockConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  late MockConnectionChecker mockConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockConnectionChecker = MockConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockConnectionChecker);
  });

  group('is connected', () {
    test(
      "should forward the call to DataConnectionChecker.hasConnection",
      () async {
        //arrange
        final tHasConnectionFuture = Future.value(true);

        when(() => networkInfoImpl.isConnected)
            .thenAnswer((invocation) => tHasConnectionFuture);
        //act
        final result = networkInfoImpl.isConnected;

        //assert
        verify(() => mockConnectionChecker.hasConnection).called(1);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
