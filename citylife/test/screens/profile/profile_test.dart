import 'package:citylife/screens/login/2fa_login_state.dart';
import 'package:citylife/screens/profile/local_widgets/profile_two_factors_auth.dart';
import 'package:citylife/screens/profile/profile.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:citylife/widgets/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../mocks/api_services_mock.dart';
import '../../mocks/auth_service_mock.dart';
import '../../mocks/two_factors_auth_mock.dart';
import '../../utils/model_mocks.dart';

main() async {
  await (FontLoader("Montserrat")).load();
  final authService = MockAuthService();
  final userAPIService = MockUserAPIService();
  final badgeAPIService = MockBadgeAPIService();
  final twoFALoginState = MockTwoFALoginState();
  final authUser = MockModel.getUser();
  when(authService.authUser).thenReturn(authUser);

  BadgeDialogState badgeDialogState = BadgeDialogState(authService);
  group('Profile -', () {
    Widget testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
        ChangeNotifierProvider<TwoFALoginState>.value(value: twoFALoginState),
        Provider<UserAPIService>.value(value: userAPIService),
        Provider<BadgeAPIService>.value(value: badgeAPIService),
        Provider<BadgeDialogState>.value(value: badgeDialogState),
      ],
      child: MaterialApp(home: Profile()),
    );
    group('all elements are correctly positioned -', () {
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

        final switchFinder = find.byType(Switch);
        expect(switchFinder, findsOneWidget);
        expect((switchFinder.first.evaluate().single.widget as Switch).value,
            authUser.tech);
      });
      testWidgets('form button', (t) async {
        await t.pumpWidget(testApp);

        final buttonFinder = find.byType(CustomGradientButton);
        expect(buttonFinder, findsOneWidget);
      });
    });
    group('interactions', () {
      testWidgets('edit name changes button', (t) async {
        await t.pumpWidget(testApp);

        final nameFinder = find.text(authUser.name);
        expect(nameFinder, findsOneWidget);
        expect(nameFinder.first.evaluate().single.widget, isA<EditableText>());
        await t.enterText(nameFinder, "edit");
        await t.pumpAndSettle();

        final signOutButtonFinder = find.text("Sign out");
        expect(signOutButtonFinder, findsNothing);
        final saveButtonFinder = find.text("Save profile");
        expect(saveButtonFinder, findsOneWidget);
      });
      testWidgets('save profile after edit - no techie', (t) async {
        when(userAPIService.route("/update", body: authUser))
            .thenAnswer((_) async => authUser);
        await t.pumpWidget(testApp);

        // * Edit the name field
        final nameFinder = find.text(authUser.name);
        expect(nameFinder, findsOneWidget);
        expect(nameFinder.first.evaluate().single.widget, isA<EditableText>());
        await t.enterText(nameFinder, "");
        await t.pumpAndSettle();
        final saveButtonFinder = find.text("Save profile");
        expect(saveButtonFinder, findsOneWidget);

        // * tap the save button
        await t.tap(saveButtonFinder);
        await t.pumpAndSettle();

        final signOutButtonFinder = find.text("Sign out");
        expect(signOutButtonFinder, findsOneWidget);
        expect(saveButtonFinder, findsNothing);
      });
      testWidgets('save profile after edit - techie', (t) async {
        when(userAPIService.route("/update", body: authUser))
            .thenAnswer((_) async => authUser);
        when(badgeAPIService.route("/techie", urlArgs: authUser.id))
            .thenAnswer((_) async => null);

        await t.pumpWidget(testApp);

        // * Edit the name field
        final switchFinder = find.byType(Switch);
        expect(switchFinder, findsOneWidget);
        await t.tap(switchFinder);
        await t.pumpAndSettle();

        final dialogFinder = find.byType(AlertDialog);
        expect(dialogFinder, findsOneWidget);

        final returnButtonFinder = find.text("Probably I'm not");
        expect(returnButtonFinder, findsOneWidget);
        final confirmButtonFinder = find.text("I'm a techie");
        expect(confirmButtonFinder, findsOneWidget);

        await t.tap(returnButtonFinder);
        await t.pumpAndSettle();
        expect(dialogFinder, findsNothing);

        await t.tap(switchFinder);
        await t.pumpAndSettle();
        expect(dialogFinder, findsOneWidget);

        await t.tap(confirmButtonFinder);
        await t.pumpAndSettle();
        expect(authUser.tech, true);

        final saveButtonFinder = find.text("Save profile");
        expect(saveButtonFinder, findsOneWidget);

        // * tap the save button
        await t.tap(saveButtonFinder);
        await t.pump();

        final signOutButtonFinder = find.text("Sign out");
        expect(signOutButtonFinder, findsOneWidget);
        expect(saveButtonFinder, findsNothing);

        await t.tap(switchFinder);
      });
      testWidgets('check technical user description', (t) async {
        await t.pumpWidget(testApp);

        final iconFinder = find.byIcon(Icons.error_outline_rounded);
        expect(iconFinder, findsOneWidget);

        final gestureDetectorFinder = find.ancestor(
          of: iconFinder,
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetectorFinder, findsOneWidget);
        expect(gestureDetectorFinder.evaluate().first.widget,
            isA<GestureDetector>());
        await t.tap(gestureDetectorFinder);
        await t.pumpAndSettle();

        final dialogFinder = find.byType(AlertDialog);
        expect(dialogFinder, findsOneWidget);

        final textFinders =
            find.descendant(of: dialogFinder, matching: find.byType(Text));
        expect(textFinders, findsNWidgets(3));
        final gradientButton = find.descendant(
            of: dialogFinder, matching: find.byType(CustomGradientButton));
        expect(gradientButton, findsOneWidget);

        await t.tap(gradientButton);
        await t.pumpAndSettle();

        expect(dialogFinder, findsNothing);
        expect(gradientButton, findsNothing);
        expect(textFinders, findsNothing);
      });
      testWidgets('two factor authentication', (t) async {
        final secret = "Test Secret";

        when(userAPIService.route("/2fa/getSecret", urlArgs: authUser.id))
            .thenAnswer((_) async => secret);

        await t.pumpWidget(testApp);

        final twoFATextFinder = find.text("2 Factor Authentication");
        expect(twoFATextFinder, findsOneWidget);

        final locked2FAFinder = find.byIcon(Icons.lock_outline);
        final unlocked2FAFinder = find.byIcon(Icons.lock_open_outlined);
        expect(locked2FAFinder, authUser.twofa ? findsOneWidget : findsNothing);
        expect(
            unlocked2FAFinder, authUser.twofa ? findsNothing : findsOneWidget);

        final inkWellFinder =
            find.ancestor(of: twoFATextFinder, matching: find.byType(InkWell));

        expect(inkWellFinder, findsOneWidget);

        await t.tap(inkWellFinder);
        await t.pumpAndSettle();

        final profile2FADialogFinder = find.byType(ProfileTwoFactorsAuth);
        expect(profile2FADialogFinder, findsOneWidget);

        final dialogFinder = find.byType(Dialog);
        expect(dialogFinder, findsOneWidget);

        final qrFinder = find.byType(QrImage);
        expect(qrFinder, findsOneWidget);

        final secretFinder = find.text(secret);
        expect(secretFinder, findsOneWidget);

        final iconCopiedFinder = find.byIcon(Icons.done);
        expect(iconCopiedFinder, findsNothing);
        final iconNotCopiedFinder = find.byIcon(Icons.content_copy);
        expect(iconNotCopiedFinder, findsNothing);

        final openGAuthFinder = find.text("Open Authenticator");
        expect(openGAuthFinder, findsOneWidget);

        final doneFinder = find.text("Done");
        expect(doneFinder, findsOneWidget);

        await t.tap(doneFinder);
        await t.pumpAndSettle();

        expect(dialogFinder, findsNothing);
        expect(qrFinder, findsNothing);
        expect(secretFinder, findsNothing);
        expect(openGAuthFinder, findsNothing);
        expect(doneFinder, findsNothing);
      });
    });
  });
}
