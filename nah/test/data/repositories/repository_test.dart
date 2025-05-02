//mock the hymnal service
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/nah_services_export.dart';
import 'package:path/path.dart' as p;

//Mock the hymn & hymnal service
class MockHymnalService with Mock implements HymnalService {}

class MockHymnService with Mock implements HymnService {}

class MockDatabaseHelper with Mock implements DatabaseHelper {}

void main() {
  late HymnalRepository hymnalRepository;
  late HymnRepository hymnRepository;
  late MockHymnalService mockHymnalService;
  late MockHymnService mockHymnService;
  late MockDatabaseHelper mockDatabaseHelper;
  setUp(() {
    mockHymnalService = MockHymnalService();
    mockHymnService = MockHymnService();
    mockDatabaseHelper = MockDatabaseHelper();
    hymnalRepository = HymnalRepository(mockHymnalService, mockDatabaseHelper);
    hymnRepository = HymnRepository(mockHymnService);
  });

  group('Test the hymn & hymnal repositories', () {
    const mockHymnalJson = '''
      [
        {"id": 1, "title": "Hymnal 1", "language": "English"},
        {"id": 2, "title": "Hymnal 2", "language": "French"}
      ]
    ''';

    final mockHymnals = [
      Hymnal(id: 1, title: "Hymnal 1", language: "English"),
      Hymnal(id: 2, title: "Hymnal 2", language: "French"),
    ];

    test('Test getting hymnals from the service', () async {
      //Arrange
      when(
        () => mockHymnalService.fetchHymnalsWithRetry(),
      ).thenAnswer((_) async => Success(mockHymnalJson));
      when(
        () => mockDatabaseHelper.insertHymnals(any()),
      ).thenAnswer((_) async => Future.value());

      //ACT
      final result = await hymnalRepository.getHymnals();

      //Assert
      expect(result, isA<Success<List<Hymnal>>>());
      expect((result as Success<List<Hymnal>>).data, equals(mockHymnals));
      verify(() => mockHymnalService.fetchHymnalsWithRetry()).called(1);
      verify(() => mockDatabaseHelper.insertHymnals(mockHymnals)).called(1);
    });

    test(
      'Test receiving an error from hymnal service and fallback on cached hymnals',
      () async {
        //Arrange
        when(
          () => mockHymnalService.fetchHymnalsWithRetry(),
        ).thenAnswer((_) async => Failure(Exception('Error fetching hymns')));
        when(
          () => mockDatabaseHelper.getHymnals(),
        ).thenAnswer((_) async => mockHymnals);

        //Act
        final result = await hymnalRepository.getHymnals();

        //Assert
        expect(result, isA<Success<List<Hymnal>>>());
        verify(() => mockHymnalService.fetchHymnalsWithRetry()).called(1);
        verify(() => mockDatabaseHelper.getHymnals()).called(1);
      },
    );

    test('Should return failure when both service and cache fail', () async {
      // Arrange
      when(
        () => mockHymnalService.fetchHymnalsWithRetry(),
      ).thenAnswer((_) async => Failure(Exception('Network error')));
      when(() => mockDatabaseHelper.getHymnals()).thenAnswer((_) async => []);

      // Act
      final result = await hymnalRepository.getHymnals();

      // Assert
      expect(result, isA<Failure>());
      verify(() => mockHymnalService.fetchHymnalsWithRetry()).called(1);
      verify(() => mockDatabaseHelper.getHymnals()).called(1);
    });

    //variable to hold language of hymns
    final language = 'Chichewa';
    test('Test getting hymns from hymnservice with success', () async {
      //Arrange
      when(() => mockHymnService.fetchHymns(language)).thenAnswer(
        (_) async => Success(
          '[{"id":1,"title":"Chichewa hymn","otherDetails":"Other details","lyrics":{"verses":[""],"chorus":""}}]',
        ),
      );
      //Act
      final result = await hymnRepository.getHymns(language);
      //Assert
      expect(result, isA<Success<List<Hymn>>>());
      expect((result as Success<List<Hymn>>).data.first.title, 'Chichewa hymn');
    });

    test('Getting an error from hymn service in hymn repo', () async {
      //Arrange
      when(
        () => mockHymnService.fetchHymns(language),
      ).thenAnswer((_) async => Failure(Exception('Error fetching hymns')));

      //Act
      final result = await hymnRepository.getHymns(language);

      //Assert
      expect(result, isA<Failure>());
    });
  });
}
