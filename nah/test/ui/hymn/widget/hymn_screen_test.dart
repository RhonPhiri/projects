import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
import 'package:nah/ui/hymn/widgets/hymn_screen.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:provider/provider.dart';
import '../../../../mocks/test_mocks.dart';
import '../../../../mocks/test_variables.dart';

void main() {
  late MockHymnalProvider mockHymnalProvider;
  late MockHymnProvider mockHymnProvider;

  setUp(() {
    mockHymnProvider = MockHymnProvider();
    mockHymnalProvider = MockHymnalProvider();
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HymnalProvider>.value(value: mockHymnalProvider),
        ChangeNotifierProvider<HymnProvider>.value(value: mockHymnProvider),
      ],
      child: MaterialApp(home: HymnScreen()),
    );
  }

  group('Hymn Screen widget test', () {
    testWidgets('Testing hymn screen loading', (WidgetTester tester) async {
      //Arrange
      when(
        () => mockHymnalProvider.loadHymnals(),
      ).thenAnswer((_) async => Future.value());
      when(() => mockHymnalProvider.selectedHymnal).thenReturn(0);
      when(
        () => mockHymnProvider.loadHymns(chiLanguage),
      ).thenAnswer((_) async => Future.value());
      when(() => mockHymnalProvider.hymnals).thenReturn(hymnalList);
      when(() => mockHymnProvider.hymnList).thenReturn(hymnList);
      when(() => mockHymnalProvider.isLoading).thenReturn(true);
      when(() => mockHymnProvider.isLoading).thenReturn(true);

      //act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(Duration(seconds: 1));

      //Assert
      expect(
        find.byKey(ValueKey('hymnScreenProgressIndicator')),
        findsOneWidget,
      );
    });
  });
}
