import 'package:citylife/screens/login/login.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:citylife/widgets/custom_gradient_button.dart';
import 'package:citylife/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../mocks/api_services_mock.dart';
import '../../mocks/auth_service_mock.dart';
import '../../mocks/badge_dialog_state_mock.dart';
import '../../mocks/firebase_auth_mock.dart';
import '../../utils/mock_firebase_credential.dart';
import '../../utils/model_mocks.dart';

main() {
  final user = MockModel.getUser();
  final firebaseUser = MockUser();
  final firebaseAuth = MockFirebaseAuth(currentUserField: firebaseUser);
  final authService = MockAuthService(auth: firebaseAuth);
  final badgeDialogState = MockBadgeDialogState();
  final badgeAPIService = MockBadgeAPIService();
  when(authService.authUser).thenReturn(user);

  final testApp = MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthService>.value(value: authService),
      Provider<BadgeDialogState>.value(value: badgeDialogState),
      Provider<BadgeAPIService>.value(value: badgeAPIService),
    ],
    child: MaterialApp(
      home: Login(),
    ),
  );
  group('Login', () {
    group('all elements are correctly positioned -', () {
      testWidgets('social login buttons', (t) async {
        await t.pumpWidget(testApp);

        final socialButtonsFinder = find.byType(ClipOval);
        expect(socialButtonsFinder, findsNWidgets(4));
        // * All social buttons must be in a row
        expect(
            find.ancestor(
                of: socialButtonsFinder.first, matching: find.byType(Row)),
            findsOneWidget);
      });
      testWidgets('form elements', (t) async {
        await t.pumpWidget(testApp);

        final formFinder = find.byType(Form);
        expect(formFinder, findsOneWidget);
        expect(
            (formFinder.evaluate().first.widget as Form).child, isA<Column>());
        final editableFieldsFinder = find.descendant(
            of: formFinder, matching: find.byType(TextFormField));
        expect(editableFieldsFinder, findsNWidgets(2));

        final orLoginWithFinder = find.text('or log in with');
        expect(orLoginWithFinder, findsOneWidget);
        final rowFinder =
            find.ancestor(of: orLoginWithFinder, matching: find.byType(Row));
        expect(rowFinder, findsOneWidget);
        final dividersFinder =
            find.descendant(of: rowFinder, matching: find.byType(Divider));
        expect(dividersFinder, findsNWidgets(2));
        final signInTextFinder = find.text('Sign In');
        expect(signInTextFinder, findsOneWidget);
        expect(
          find.ancestor(
            of: signInTextFinder,
            matching: find.byType(CustomGradientButton),
          ),
          findsOneWidget,
        );
      });
    });
    group('interactions -', () {
      group('email/pswd login:', () {
        final email = "test@test.com";
        final password = "test_password";
        testWidgets('successful login', (t) async {
          when(authService.signInWithEmailAndPassword(email, password))
              .thenAnswer((_) async => user);
          when(badgeAPIService.route("/login", urlArgs: user.id))
              .thenAnswer((_) => null);
          await t.pumpWidget(testApp);

          final emailTextFinder = find.text('Email');
          final emailFieldFinder = find.ancestor(
            of: emailTextFinder,
            matching: find.byType(TextFormField),
          );
          expect(emailFieldFinder, findsOneWidget);
          expect(emailTextFinder, findsOneWidget);

          final passwordTextFinder = find.text('Password');
          final passwordFieldFinder = find.ancestor(
            of: passwordTextFinder,
            matching: find.byType(TextFormField),
          );
          expect(passwordTextFinder, findsOneWidget);
          expect(passwordFieldFinder, findsOneWidget);

          await t.enterText(emailFieldFinder, email);
          await t.enterText(passwordFieldFinder, password);
          await t.pumpAndSettle();

          final signInButtonFinder = find.byType(CustomGradientButton);
          expect(signInButtonFinder, findsOneWidget);

          await t.tap(signInButtonFinder);
          await t.pumpAndSettle();
        });
        testWidgets('failure', (t) async {
          final errorMessage = "Some general error";
          when(authService.signInWithEmailAndPassword(email, password))
              .thenThrow(AuthException(errorMessage));
          await t.pumpWidget(testApp);

          final emailTextFinder = find.text('Email');
          final emailFieldFinder = find.ancestor(
            of: emailTextFinder,
            matching: find.byType(TextFormField),
          );
          expect(emailFieldFinder, findsOneWidget);
          expect(emailTextFinder, findsOneWidget);

          final passwordTextFinder = find.text('Password');
          final passwordFieldFinder = find.ancestor(
            of: passwordTextFinder,
            matching: find.byType(TextFormField),
          );
          expect(passwordTextFinder, findsOneWidget);
          expect(passwordFieldFinder, findsOneWidget);

          await t.enterText(emailFieldFinder, email);
          await t.enterText(passwordFieldFinder, password);
          await t.pumpAndSettle();

          final signInButtonFinder = find.byType(CustomGradientButton);
          expect(signInButtonFinder, findsOneWidget);

          await t.tap(signInButtonFinder);
          await t.pump();

          final toastFinder = find.byType(SnackBar);
          expect(toastFinder, findsOneWidget);
          final textFinder =
              find.descendant(of: toastFinder, matching: find.byType(Text));
          expect(textFinder, findsOneWidget);
          expect(
              (textFinder.evaluate().first.widget as Text).data, errorMessage);
        });
        testWidgets('authenticate email', (t) async {
          final errorMessage = "Sent verification email";
          when(authService.signInWithEmailAndPassword(email, password))
              .thenThrow(AuthException(errorMessage));
          when(authService.signInWithEmailAndPassword(email, password,
                  verifiedEmail: true))
              .thenAnswer((_) async => user);
          when(badgeAPIService.route("/login", urlArgs: user.id))
              .thenAnswer((_) => null);
          await t.pumpWidget(testApp);

          final emailTextFinder = find.text('Email');
          final emailFieldFinder = find.ancestor(
            of: emailTextFinder,
            matching: find.byType(TextFormField),
          );
          expect(emailFieldFinder, findsOneWidget);
          expect(emailTextFinder, findsOneWidget);

          final passwordTextFinder = find.text('Password');
          final passwordFieldFinder = find.ancestor(
            of: passwordTextFinder,
            matching: find.byType(TextFormField),
          );
          expect(passwordTextFinder, findsOneWidget);
          expect(passwordFieldFinder, findsOneWidget);

          await t.enterText(emailFieldFinder, email);
          await t.enterText(passwordFieldFinder, password);
          await t.pumpAndSettle();

          final signInButtonFinder = find.byType(CustomGradientButton);
          expect(signInButtonFinder, findsOneWidget);

          await t.tap(signInButtonFinder);
          await t.pump();

          final toastFinder = find.byType(SnackBar);
          expect(toastFinder, findsOneWidget);
          final textFinder =
              find.descendant(of: toastFinder, matching: find.byType(Text));
          expect(textFinder, findsOneWidget);
          expect((textFinder.evaluate().first.widget as Text).data,
              contains(errorMessage));
        });
      });
      group('social logins:', () {
        testWidgets('Google', (t) async {
          when(authService.signInWithGoogle()).thenAnswer((_) async => user);
          when(badgeAPIService.route("/login", urlArgs: user.id))
              .thenAnswer((_) => null);
          await t.pumpWidget(testApp);

          final buttonsFinder = find.byType(ClipOval);
          expect(buttonsFinder, findsNWidgets(4));

          final googleButtonFinder = buttonsFinder.first;
          final imageFinder = find.descendant(
              of: googleButtonFinder, matching: find.byType(Image));
          expect(imageFinder, findsOneWidget);
          expect(
              (imageFinder.evaluate().first.widget as Image).image, L.Google);

          await t.tap(googleButtonFinder);

          await t.pumpAndSettle();
          expect(find.byType(SnackBar), findsNothing);
        });
        testWidgets('Twitter', (t) async {
          when(authService.signInWithTwitter()).thenAnswer((_) async => user);
          when(badgeAPIService.route("/login", urlArgs: user.id))
              .thenAnswer((_) => null);
          await t.pumpWidget(testApp);

          final buttonsFinder = find.byType(ClipOval);
          expect(buttonsFinder, findsNWidgets(4));

          final twitterButtonFinder = buttonsFinder.at(1);
          final twitterButton =
              twitterButtonFinder.evaluate().first.widget as ClipOval;
          final imageFinder = find.descendant(
              of: twitterButtonFinder, matching: find.byType(Image));
          expect(imageFinder, findsOneWidget);
          expect(
              (imageFinder.evaluate().first.widget as Image).image, L.Twitter);

          await t.tap(twitterButtonFinder);

          await t.pumpAndSettle();
          expect(find.byType(SnackBar), findsNothing);
        });
        testWidgets('Facebook', (t) async {
          when(authService.signInWithFacebook()).thenAnswer((_) async => user);
          when(badgeAPIService.route("/login", urlArgs: user.id))
              .thenAnswer((_) => null);
          await t.pumpWidget(testApp);

          final buttonsFinder = find.byType(ClipOval);
          expect(buttonsFinder, findsNWidgets(4));

          final facebookButtonFinder = buttonsFinder.last;
          final facebookButton =
              facebookButtonFinder.evaluate().first.widget as ClipOval;
          final imageFinder = find.descendant(
              of: facebookButtonFinder, matching: find.byType(Image));
          expect(imageFinder, findsOneWidget);
          expect(
              (imageFinder.evaluate().first.widget as Image).image, L.Facebook);

          await t.tap(facebookButtonFinder);

          await t.pumpAndSettle();
          expect(find.byType(SnackBar), findsNothing);
        });
      });
      group('social logins errors:', () {
        testWidgets('Google', (t) async {
          when(authService.signInWithGoogle()).thenThrow(Exception());
          await t.pumpWidget(testApp);

          final buttonsFinder = find.byType(ClipOval);
          expect(buttonsFinder, findsNWidgets(4));

          final googleButtonFinder = buttonsFinder.first;
          final googleButton =
              googleButtonFinder.evaluate().first.widget as ClipOval;
          final imageFinder = find.descendant(
              of: googleButtonFinder, matching: find.byType(Image));
          expect(imageFinder, findsOneWidget);
          expect(
              (imageFinder.evaluate().first.widget as Image).image, L.Google);

          await t.tap(googleButtonFinder);
          await t.pump();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(
              find.text("Error occured while authenticating"), findsOneWidget);
        });
        testWidgets('Twitter', (t) async {
          when(authService.signInWithTwitter()).thenThrow(Exception());
          await t.pumpWidget(testApp);

          final buttonsFinder = find.byType(ClipOval);
          expect(buttonsFinder, findsNWidgets(4));

          final twitterButtonFinder = buttonsFinder.at(1);
          final twitterButton =
              twitterButtonFinder.evaluate().first.widget as ClipOval;
          final imageFinder = find.descendant(
              of: twitterButtonFinder, matching: find.byType(Image));
          expect(imageFinder, findsOneWidget);
          expect(
              (imageFinder.evaluate().first.widget as Image).image, L.Twitter);

          await t.tap(twitterButtonFinder);
          await t.pump();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(
              find.text("Error occured while authenticating"), findsOneWidget);
        });
        testWidgets('Facebook', (t) async {
          when(authService.signInWithFacebook()).thenThrow(Exception());
          await t.pumpWidget(testApp);

          final buttonsFinder = find.byType(ClipOval);
          expect(buttonsFinder, findsNWidgets(4));

          final facebookButtonFinder = buttonsFinder.last;
          final facebookButton =
              facebookButtonFinder.evaluate().first.widget as ClipOval;
          final imageFinder = find.descendant(
              of: facebookButtonFinder, matching: find.byType(Image));
          expect(imageFinder, findsOneWidget);
          expect(
              (imageFinder.evaluate().first.widget as Image).image, L.Facebook);

          await t.tap(facebookButtonFinder);
          await t.pump();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(
              find.text("Error occured while authenticating"), findsOneWidget);
        });
      });
    });
  });
}
