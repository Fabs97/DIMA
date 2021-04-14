import 'package:citylife/screens/login/2fa_login_state.dart';
import 'package:citylife/screens/profile/profile.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../mocks/auth_service_mock.dart';
import '../../mocks/build_context_mock.dart';
import '../../mocks/two_factors_auth_mock.dart';
import '../../mocks/user_api_service_mock.dart';
import '../../utils/model_mocks.dart';

main() {
  final authService = MockAuthService();
  final userAPIService = MockUserAPIService();
  final buildContext = MockBuildContext();
  final twoFALoginState = MockTwoFALoginState();
  final authUser = MockModel.getUser();
  when(authService.authUser).thenReturn(authUser);

  final badgeDialogState = BadgeDialogState(buildContext, authService);
  group('Profile -', () {
    group('all elements are correctly positioned -', () {
      Widget testApp = MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>.value(value: authService),
          ChangeNotifierProvider<TwoFALoginState>.value(value: twoFALoginState),
          Provider<UserAPIService>.value(value: userAPIService),
          Provider<BadgeDialogState>.value(value: badgeDialogState),
        ],
        child: MaterialApp(
          home: Profile(),
        ),
      );

      testWidgets('experience bar', (t) async {
        await t.pumpWidget(testApp);

        final lvlTexts = find.textContaining("LVL.");
        expect(lvlTexts, findsNWidgets(2));
        final currentLevel = int.parse(
            (lvlTexts.at(0).evaluate().single.widget as Text)
                .data
                .substring("LVL. ".length));
        final nextLevel = int.parse(
            (lvlTexts.at(1).evaluate().single.widget as Text)
                .data
                .substring("LVL. ".length));

        expect(nextLevel, currentLevel + 1);

        final linearIndicator = find.byType(LinearProgressIndicator);
        expect(linearIndicator, findsOneWidget);
        expect(
            (linearIndicator.first.evaluate().single.widget
                    as LinearProgressIndicator)
                .value,
            authUser.exp);
      });
      testWidgets('user info form', (t) async {
        await t.pumpWidget(testApp);

        final userNameFinder = find.text(authUser.name);
        expect(userNameFinder, findsOneWidget);

        final userNameWidget =
            userNameFinder.first.evaluate().single.widget as EditableText;
        expect(userNameWidget, isA<EditableText>());
        expect(userNameWidget.obscureText, false);
        expect(userNameWidget.readOnly, false);
        expect(userNameWidget.textAlign, TextAlign.start);

        final iconsFinder = find.byType(Icon);
        expect(iconsFinder, findsNWidgets(5));
      });
    });
  });
}
