import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/services/hymnal_service.dart';
import 'package:http/http.dart' as http;
import 'package:nah/data/services/result.dart';

//first, create the mock class by mixing Mock & implementing http.Client()
class MockHttpClient with Mock implements http.Client {}

//create the Fake class to provide the dummy uri for Uri
class FakeUri extends Fake implements Uri {}

void main() {
  //Will use the arrange, act & assert pattern

  late HymnalService hymnalService;
  late MockHttpClient mockHttpClient;

  //providing a dummy uri for Uri when using any() as required by mocktail
  //Also a Fake class can be defined
  setUpAll(() {
    //register a fake uri
    registerFallbackValue(FakeUri());
  });

  //Initialize the classes
  setUp(() {
    mockHttpClient = MockHttpClient();
    //inject the mock into the hymnalservice class
    hymnalService = HymnalService(client: mockHttpClient);
  });

  group('Testing the hymnal service class', () {
    test('fetch hymnals returns success when response is 200', () async {
      //ARRANGE: this is where everything needded is set up; initializations, mocking preparing input data
      //Defining the behavior of the mock
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(
          '[{{"id":1,"language":"Chichewa","title":"Nyimbo za NAC"}}]',
          200,
        ),
      );

      //Act: Execution of code under test
      final result = await hymnalService.fetchHymnals();

      //Assert: verify the result
      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, contains('Nyimbo za NAC'));
    });

    test('Fetch hymnals returns failure when response is not 200', () async {
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response('Error', 404));

      final result = await hymnalService.fetchHymnals();

      expect(result, isA<Failure>());
    });

    test('Fetch hymnals with retries', () async {
      //Arrange
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(
          '[{{"id":1,"language":"Chichewa","title":"Nyimbo za NAC"}}]',
          200,
        ),
      );

      //Act
      final result = await hymnalService.fetchHymnalsWithRetry();

      //Assert
      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, contains('Chichewa'));
    });

    test('error fetching hymnals with retries', () async {
      //Arrange
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response('Error', 404));
      //Act
      final result = await hymnalService.fetchHymnalsWithRetry();

      //Assert
      expect(result, isA<Failure>());
    });
  });
}
