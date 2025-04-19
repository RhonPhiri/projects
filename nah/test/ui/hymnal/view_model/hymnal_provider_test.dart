import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/result.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';

//mocking the repository class with mochtail
class MockHymnalRepository with Mock implements HymnalRepository {}

//
void main() {
  //initialize the needed classes
  late MockHymnalRepository mockHymnalRepository;
  late HymnalProvider hymnalProvider;

  setUp(() {
    mockHymnalRepository = MockHymnalRepository();
    hymnalProvider = HymnalProvider(mockHymnalRepository);
  });

  group('Testing hymnal provider functionality', () {
    test('Test loading hymns from repository with success', () async {
      //Arrange
      when(() => mockHymnalRepository.getHymnals()).thenAnswer(
        (_) async => Success([
          Hymnal(id: 1, language: "Chichewa", title: "Nyimbo za NAC"),
        ]),
      );

      //Act
      await hymnalProvider.loadHymnals();

      //Assert
      expect(hymnalProvider.hymnals.length, 1);
      expect(hymnalProvider.hymnals.first.title, "Nyimbo za NAC");
    });

    test('Test receiving an error from repo', () async {
      //Arrange
      when(
        () => mockHymnalRepository.getHymnals(),
      ).thenAnswer((_) async => Failure(Exception('Error getting hymnals')));

      //Act
      await hymnalProvider.loadHymnals();

      //Assert
      expect(hymnalProvider.errorMessage, isNotNull);
      expect(hymnalProvider.hymnals.isEmpty, true);
    });
  });
}
