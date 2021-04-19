import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/badge.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:citylife/utils/constants.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/auth_service_mock.dart';

main() {
  final authService = MockAuthService();
  final badgeDialogState = BadgeDialogState(authService);
  final controller = ConfettiController();
  final testApp = MaterialApp(
    home: LayoutBuilder(
      builder: (context, _) => ElevatedButton(
        child: Text("Test"),
        onPressed: () {
          badgeDialogState.showBadgeDialog(
            Badge.Techie,
            controller,
            context,
          );
        },
      ),
    ),
  );
  group('Badge Dialog State -', () {
    testWidgets('all parts are correctly placed', (t) async {
      await t.pumpWidget(testApp);

      await t.tap(find.byType(ElevatedButton));
      await t.pump();

      final dialogFinder = find.byType(Dialog);
      expect(dialogFinder, findsOneWidget);

      final textFinder = find.textContaining(B.adges[Badge.Techie].text);
      expect(textFinder, findsOneWidget);

      final confettiFinder = find.byType(ConfettiWidget);
      expect(confettiFinder, findsOneWidget);

      await t.tapAt(t.getCenter(dialogFinder));
      await t.pump();

      expect(dialogFinder, findsNothing);
      expect(textFinder, findsNothing);
      expect(confettiFinder, findsNothing);
    });
  });
  tearDown(() {
    controller.dispose();
  });
}
