//testing the hymn repository

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/services/result.dart';
import '../../../mocks/test_mocks.dart';

late MockHymnService mockHymnService;
late MockDatabaseHelper mockDatabaseHelper;
late HymnRepository hymnRepository;
void main() {
  setUp(() {
    mockHymnService = MockHymnService();
    mockDatabaseHelper = MockDatabaseHelper();
    hymnRepository = HymnRepository(mockHymnService, mockDatabaseHelper);
  });
  group('Testing the hymn repository methods & functionality', () {
    //variable to hold language of hymns
    final language = 'Chichewa';
    test('Test getting hymns from hymnservice with success', () async {
      //Arrange
      when(() => mockHymnService.fetchHymns(language)).thenAnswer(
        (_) async => Success(
          '[{"id":1,"title":"Chichewa hymn","otherDetails":"Other details","lyrics":{"verses":[""],"chorus":""}}]',
        ),
      );
      when(
        () => mockDatabaseHelper.insertHymns(any()),
      ).thenAnswer((_) async => Future.value());

      //Act
      final result = await hymnRepository.getHymns(language);
      //Assert
      expect(result, isA<Success<List<Hymn>>>());
      expect((result as Success<List<Hymn>>).data.first.title, 'Chichewa hymn');

      //verify that the database insert method is called upon returning a success from service
      verify(() => mockDatabaseHelper.insertHymns(any())).called(1);
    });

    test(
      'Getting an error from hymn service in hymn repo & falling back on cached hymns',
      () async {
        //Arrange
        when(
          () => mockHymnService.fetchHymns(language),
        ).thenAnswer((_) async => Failure(Exception('Error fetching hymns')));
        when(() => mockDatabaseHelper.getHymns()).thenAnswer(
          (_) async => [
            Hymn(
              id: 1,
              title: "Chichewa Hymn",
              otherDetails: "Other Details",
              lyrics: {
                "verses": [""],
                "chorus": "",
              },
            ),
          ],
        );

        //Act
        final result = await hymnRepository.getHymns(language);

        //Assert
        expect(result, isA<Success<List<Hymn>>>());
        verify(() => mockHymnService.fetchHymns(language)).called(1);
        verify(() => mockDatabaseHelper.getHymns()).called(1);
      },
    );

    test(
      'Testing receiving an error from service & not having a an empty list from database',
      () async {
        //Arrange
        when(
          () => mockHymnService.fetchHymns(language),
        ).thenAnswer((_) async => Failure(Exception('Error fetching hymns')));
        when(() => mockDatabaseHelper.getHymns()).thenAnswer((_) async => []);

        //ACT
        final result = await hymnRepository.getHymns(language);

        //Assert
        expect(result, isA<Failure>());
        verify(() => mockHymnService.fetchHymns(language)).called(1);
        verify(() => mockDatabaseHelper.getHymns()).called(1);
      },
    );
  });
}
