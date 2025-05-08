// Testing loading hymns from hymn repo
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/services/nah_services_export.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
import '../../../../mocks/test_mocks.dart';
import '../../../../mocks/test_variables.dart';

void main() {
  late MockHymnRepository mockHymnRepository;
  late HymnProvider hymnProvider;

  setUp(() {
    mockHymnRepository = MockHymnRepository();
    hymnProvider = HymnProvider(mockHymnRepository);
  });

  group('Testing the load hymns method in hym provider', () {
    test('Testing loading hymns with success in the hymn provider', () async {
      //Arrange
      when(
        () => mockHymnRepository.getHymns(chiLanguage.toLowerCase()),
      ).thenAnswer((_) async => Success(hymnList));

      //mocking expricitly, so that when load hymns is called, a fututre<void> is returned
      // when(
      //   () => mockHymnProvider.loadHymns(chiLanguage),
      // ).thenAnswer((_) async => Future.value());

      //Act
      await hymnProvider.loadHymns(chiLanguage);

      //Assert
      expect(hymnProvider.hymnList.length, 1);
      expect(hymnProvider.errorMessage, isEmpty);
    });

    test('Testing loading hymns with Failure', () async {
      //Arrange
      when(() => mockHymnRepository.getHymns(chiLanguage)).thenAnswer(
        (_) async =>
            Failure(Exception('Failed to load hymns from hymn service')),
      );

      //Act
      await hymnProvider.loadHymns(chiLanguage);

      //Assert
      expect(hymnProvider.errorMessage, isNotEmpty);
    });
  });
}
