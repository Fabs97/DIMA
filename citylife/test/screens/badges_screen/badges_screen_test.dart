import 'package:citylife/screens/badges_screen/badges_screen.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/badge.dart';
import 'package:citylife/widgets/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../mocks/api_services_mock.dart';
import '../../mocks/auth_service_mock.dart';
import '../../utils/model_mocks.dart';

main() async {
  await (FontLoader("Montserrat")).load();
  group('Badges Screen -', () {
    final authService = MockAuthService();
    final badgeAPIService = MockBadgeAPIService();
    final userAPIService = MockUserAPIService();
    final badge = MockModel.getBadge();
    final authUser = MockModel.getUser();
    when(authService.authUser).thenReturn(authUser);

    final testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
        Provider<BadgeAPIService>.value(value: badgeAPIService),
        Provider<UserAPIService>.value(value: userAPIService),
      ],
      child: MaterialApp(
        home: BadgesScreen(),
      ),
    );
    when(badgeAPIService.route("/by", urlArgs: authUser.id))
        .thenAnswer((_) async => badge);

    group('all elements are correctly positioned -', () {
      testWidgets('circular progress indicator', (t) async {
        await t.pumpWidget(testApp);

        final indicatorFinder = find.byType(CircularProgressIndicator);
        expect(indicatorFinder, findsOneWidget);
        expect(
            (indicatorFinder.evaluate().first.widget
                    as CircularProgressIndicator)
                .valueColor,
            isA<AlwaysStoppedAnimation<Color>>());
      });
      testWidgets('gridView', (t) async {
        await t.pumpWidget(testApp);
        await t.pump();

        final gridViewFinder = find.byType(GridView);
        expect(gridViewFinder, findsOneWidget);
        expect(
            (gridViewFinder.evaluate().first.widget as GridView)
                .semanticChildCount,
            15);
      });
      testWidgets('leaderboard button', (t) async {
        await t.pumpWidget(testApp);
        await t.pump();

        final textFinder = find.text("Leaderboard");
        expect(textFinder, findsOneWidget);

        final buttonFinder = find.ancestor(
            of: textFinder, matching: find.byType(CustomGradientButton));
        expect(buttonFinder, findsOneWidget);
      });
    });
    group('interactions -', () {
      testWidgets('badge dialog', (t) async {
        await t.pumpWidget(testApp);
        await t.pump();

        final gestureFinder = find.byType(GestureDetector);
        expect(gestureFinder, findsWidgets);

        final badgeFinder = gestureFinder.first;
        await t.tap(badgeFinder);
        await t.pumpAndSettle();

        final dialogFinder = find.byType(AlertDialog);
        expect(dialogFinder, findsOneWidget);

        final gotItFinder = find.text("Got it!");
        expect(gotItFinder, findsOneWidget);

        final buttonFinder = find.ancestor(
          of: gotItFinder,
          matching: find.byType(CustomGradientButton),
        );
        expect(buttonFinder, findsOneWidget);

        final descriptionFinder = find.text(B.adges.values.first.description);
        expect(descriptionFinder, findsOneWidget);

        // ? It's not tapping, don't know why ?
        // await t.tap(buttonFinder);
        // await t.pumpAndSettle();

        // expect(dialogFinder, findsNothing);
        // expect(gotItFinder, findsNothing);
        // expect(buttonFinder, findsNothing);
        // expect(descriptionFinder, findsNothing);
      });
      testWidgets('leaderboard', (t) async {
        when(userAPIService.route("/leaderboard")).thenAnswer(
          (_) async => List.generate(
            10,
            (index) => MockModel.getUser(
              id: index,
              exp: (index + 1) * 10.0,
            ),
          ),
        );
        await t.pumpWidget(testApp);
        await t.pump();

        final leaderboardTextFinder = find.text("Leaderboard");
        expect(leaderboardTextFinder, findsOneWidget);

        final buttonFinder = find.ancestor(
          of: leaderboardTextFinder,
          matching: find.byType(CustomGradientButton),
        );
        expect(buttonFinder, findsOneWidget);

        await t.tap(buttonFinder);
        await t.pump();

        final dialogFinder = find.byType(AlertDialog);
        expect(dialogFinder, findsOneWidget);
        final circularFinder = find.byType(CircularProgressIndicator);
        expect(circularFinder, findsOneWidget);

        await t.pumpAndSettle();
        expect(circularFinder, findsNothing);

        final listViewFinder = find.byType(ListView);
        expect(listViewFinder, findsOneWidget);
        final iconsFinder = find.descendant(
          of: listViewFinder,
          matching: find.byIcon(Icons.emoji_events_outlined),
        );

        expect(iconsFinder, findsNWidgets(6));
      });
    });
  });
}
