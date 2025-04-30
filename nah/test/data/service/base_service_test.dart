import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:nah/data/services/nah_services_export.dart';

//Testing the base service abstract class & associated methods

//Abstract classes can't be initialized hence implement them
class TestBaseService extends BaseService {
  TestBaseService({required http.Client client}) : super(client: client);
}

//create the mock class by mixing mock & implementing http.client()
class MockHttpClient with Mock implements http.Client {}

//creating a fakeuri class
class FakeUrl extends Fake implements Uri {}

void main() {
  //Arrange, Act & Assert pattern used

  late MockHttpClient mockHttpClient;
  late TestBaseService testBaseService;

  //provide the dummy or fake Uri
  setUpAll(() => registerFallbackValue(FakeUrl()));

  //initialize the classes
  //This method will be called before the tests are run
  setUp(() {
    mockHttpClient = MockHttpClient();
    testBaseService = TestBaseService(client: mockHttpClient);
  });

  //variable to hold the url
  final url = 'https://example.com/hymnals.json';

  group('Testing the Base_service class methods', () {
    test('Testing the fetchData method with success', () async {
      //Arrange
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(
          '[{"id":1,"language":"Chichewa","title":"Nyimbo za NAC"}]',
          200,
        ),
      );

      //Act
      final result = await testBaseService.fetchData(url);

      //Assert
      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, contains('Chichewa'));
    });

    test('Testing the fetchData method with failure', () async {
      //Arrange
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response('Error', 404));

      //Act
      final result = await testBaseService.fetchData(url);

      //Assert
      expect(result, isA<Failure<String>>());
    });
    test('Testing the fetchDataWithRetries method with success', () async {
      //Arrange: Setting up everything needed
      // when using any(), adummy url or fake uri should be provided
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(
          '[{"id":1,"language":"Chichewa","title":"Nyimbo za NAC"}]',
          200,
        ),
      );

      //Act:Execute the code under test
      final result = await testBaseService.fetchDataWithRetries(url: url);

      //Assert: Verify the result
      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, contains('Nyimbo za NAC'));
    });

    test('Testing fetchDataWithretries method with failure', () async {
      //Arrange
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response('Error', 404));

      //Act
      final result = await testBaseService.fetchDataWithRetries(url: url);

      //Assert
      expect(result, isA<Failure<String>>());
    });
  });
}
