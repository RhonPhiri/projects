import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/services/result.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import '../../../../mocks/test_mocks.dart';
import '../../../../mocks/test_variables.dart';

//
void main() {
  //initialize the needed classes
  late MockHymnalRepository mockHymnalRepository;
  late MockHymnRepository mockHymnRepository;
  late HymnalProvider hymnalProvider;

  setUp(() {
    mockHymnalRepository = MockHymnalRepository();
    mockHymnRepository = MockHymnRepository();
    hymnalProvider = HymnalProvider(mockHymnRepository, mockHymnalRepository);
  });

  group('Testing hymnal provider functionality', () {
    final language = chiLanguage;

    test('Test loading hymnals & hymns from repository with success', () async {
      //Arrange
      when(
        () => mockHymnalRepository.getHymnals(),
      ).thenAnswer((_) async => Success(hymnalList));

      when(
        () => mockHymnRepository.getHymns(language.toLowerCase()),
      ).thenAnswer((_) async => Success(hymnList));

      //Act
      await hymnalProvider.loadHymnals();

      //Assert
      expect(hymnalProvider.hymnals.length, 1);
      expect(hymnalProvider.hymnals.first.title, "Nyimbo za NAC");
    });

    test(
      'Test loading hymns from repository with success but fail for hymns',
      () async {
        //Arrange
        when(
          () => mockHymnalRepository.getHymnals(),
        ).thenAnswer((_) async => Success(hymnalList));

        when(
          () => mockHymnRepository.getHymns(language.toLowerCase()),
        ).thenAnswer((_) async => Failure(Exception('Failed to load hymns')));

        //Act
        await hymnalProvider.loadHymnals();

        //Assert
        expect(hymnalProvider.hymnals.length, 1);
        expect(hymnalProvider.hymnals.first.title, "Nyimbo za NAC");
      },
    );

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
