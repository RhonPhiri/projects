//mock the hymnal service
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/hymnal_service.dart';
import 'package:nah/data/services/result.dart';

//Mock the hymnak service
class MockHymnalService with Mock implements HymnalService {}

void main() {
  late HymnalRepository hymnalRepository;
  late MockHymnalService mockHymnalService;

  setUp(() {
    mockHymnalService = MockHymnalService();
    hymnalRepository = HymnalRepository(mockHymnalService);
  });

  group('Test the hymnal repository', () {
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
  });
}
