//mock the hymnal service
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/nah_services_export.dart';

//Mock the hymn & hymnal service
class MockHymnalService with Mock implements HymnalService {}

class MockHymnService with Mock implements HymnService {}

void main() {
  late HymnalRepository hymnalRepository;
  late HymnRepository hymnRepository;
  late MockHymnalService mockHymnalService;
  late MockHymnService mockHymnService;

  setUp(() {
    mockHymnalService = MockHymnalService();
    mockHymnService = MockHymnService();
    hymnalRepository = HymnalRepository(mockHymnalService);
    hymnRepository = HymnRepository(mockHymnService);
  });

  group('Test the hymn & hymnal repositories', () {
    test('Test getting hymnals from the service', () async {
      //Arrange
      when(() => mockHymnalService.fetchHymnalsWithRetry()).thenAnswer(
        (_) async =>
            Success('[{"id":1,"language":"Chichewa","title":"Nyimbo za NAC"}]'),
      );

      //ACT
      final result = await hymnalRepository.getHymnals();

      //Assert
      expect(result, isA<Success<List<Hymnal>>>());
      expect(
        (result as Success<List<Hymnal>>).data.first.title,
        'Nyimbo za NAC',
      );
    });

    test('Test receiving an error from hymnal service', () async {
      //Arrange
      when(
        () => mockHymnalService.fetchHymnalsWithRetry(),
      ).thenAnswer((_) async => Failure(Exception('Error fetching hymns')));
      //Act
      final result = await hymnalRepository.getHymnals();

      //Assert
      expect(result, isA<Failure>());
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
