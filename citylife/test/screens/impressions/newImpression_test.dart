import 'package:citylife/screens/impressions/emotional/emotionalImpression.dart';
import 'package:citylife/screens/impressions/newImpression.dart';
import 'package:citylife/screens/impressions/structural/structuralImpression.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../mocks/auth_service_mock.dart';
import '../../utils/model_mocks.dart';

main() async {
  final authService = MockAuthService();
  final authUser = MockModel.getUser();
  when(authService.authUser).thenReturn(authUser);
  group('Impression - ', () {
    Widget testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: NewImpression(),
        ),
      ),
    );

    testWidgets('Structural impression is triggered', (t) async {
      await t.pumpWidget(testApp);

      final dialogFinder = find.byType(Dialog);
      expect(dialogFinder, findsOneWidget);

      final elevatedButtonsFinder = find.byType(ElevatedButton);
      expect(elevatedButtonsFinder, findsNWidgets(2));

      final structButtonFinder = elevatedButtonsFinder.first;
      expect(structButtonFinder, findsOneWidget);

      await t.tapAt(t.getCenter(structButtonFinder));
      await t.pumpAndSettle();

      final structImpressionFinder = find.descendant(
          of: dialogFinder, matching: find.byType(StructuralImpression));
      expect(structImpressionFinder, findsOneWidget);
    });

    testWidgets('Emotional impression is triggered', (t) async {
      await t.pumpWidget(testApp);

      final dialogFinder = find.byType(Dialog);
      expect(dialogFinder, findsOneWidget);

      final elevatedButtonsFinder = find.byType(ElevatedButton);
      expect(elevatedButtonsFinder, findsNWidgets(2));

      final structButtonFinder = elevatedButtonsFinder.last;
      expect(structButtonFinder, findsOneWidget);

      await t.tapAt(t.getCenter(structButtonFinder));
      await t.pumpAndSettle();

      final emotionalFinder = find.descendant(
          of: dialogFinder, matching: find.byType(EmotionalImpression));
      expect(emotionalFinder, findsOneWidget);
    });
  });
}
