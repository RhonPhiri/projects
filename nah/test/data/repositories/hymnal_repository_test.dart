//Testing the hymnal repositories

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/nah_services_export.dart';
import '../../../mocks/test_mocks.dart';
import '../../../mocks/test_variables.dart';

void main() {
  late HymnalRepository hymnalRepository;
  late MockHymnalService mockHymnalService;
  late MockDatabaseHelper mockDatabaseHelper;

  //creating the instances
  setUp(() {
    mockHymnalService = MockHymnalService();
    mockDatabaseHelper = MockDatabaseHelper();
    hymnalRepository = HymnalRepository(mockHymnalService, mockDatabaseHelper);
  });

  group('Test the hymn & hymnal repositories', () {
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
  });
}
