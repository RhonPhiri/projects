import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:nah/ui/hymnal/widgets/hymnal_screen.dart';
import 'package:provider/provider.dart';
import '../../../../mocks/test_mocks.dart';
import '../../../../mocks/test_variables.dart';

void main() {
  //initializ the mock class
  late MockHymnalProvider mockHymnalProvider;

  setUp(() {
    mockHymnalProvider = MockHymnalProvider();
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<HymnalProvider>.value(
      value: mockHymnalProvider,
      child: MaterialApp(home: HymnalScreen()),
    );
  }

  group('Test the hymnal screen', () {
    //tests: scenarios
    //1. hymnals are loading
    //2. hymnals are loaded
    //TODO: 3. hymnals failed to load

    testWidgets('Displays a loading indicator when loading', (
      WidgetTester tester,
    ) async {
      //Arrange
      when(() => mockHymnalProvider.isLoading).thenReturn(true);

      //Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      //Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays a list of hymnals after loading', (
      WidgetTester tester,
    ) async {
      //Arrange
      when(() => mockHymnalProvider.isLoading).thenReturn(false);
      when(() => mockHymnalProvider.hymnals).thenReturn((hymnalList));
      when(() => mockHymnalProvider.selectedHymnal).thenReturn(0);

      //ACT
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      //Assert
      expect(find.text('Nyimbo za NAC'), findsOneWidget);
    });
  });
}
