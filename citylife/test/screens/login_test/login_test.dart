import 'package:citylife/screens/login/login.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/firebaseMock.dart';

main() {
  // setupFirebaseAuthMocks();
  // Firebase.initializeApp();

  // AuthService _authInstance;

  // final login = MaterialApp(
  //   home: MultiProvider(
  //     providers: [
  //       // This is not used, but it is required as we need to completely mock the application
  //       Provider<AuthService>(
  //         create: (context) {
  //           _authInstance = AuthService.instance();
  //           return _authInstance;
  //         },
  //       ),
  //       Provider<bool>.value(
  //         value: _authInstance.isAuthenticated,
  //       ),
  //     ],
  //     child: Login(),
  //   ),
  // );
  // group("UI test -", () {
  //   testWidgets("has logo", (tester) async {
  //     await tester.pumpWidget(login);

  //     final logo = find.byType(SvgPicture);
  //     expect(logo, findsOneWidget);
  //   });

  //   testWidgets("has divider and spacers", (tester) async {
  //     await tester.pumpWidget(login);

  //     final dividers = find.byType(Divider);
  //     final orLoginWith = find.text("or log in with");
  //     final spacers = find.byType(Spacer);
  //     expect(dividers, findsNWidgets(2));
  //     expect(spacers, findsNWidgets(2));
  //     expect(orLoginWith, findsOneWidget);
  //   });

  //   testWidgets("has form elements", (tester) async {
  //     await tester.pumpWidget(login);

  //     final formFields = find.byType(TextFormField);
  //     final signInButton = find.byType(GradientButton);
  //     expect(formFields, findsNWidgets(2));
  //     expect(signInButton, findsOneWidget);
  //   });

  //   testWidgets("has social login buttons", (tester) async {
  //     await tester.pumpWidget(login);

  //     final socialButtons = find.byType(FloatingActionButton);
  //     expect(socialButtons, findsNWidgets(4));
  //   });
  // });
  // group("Logic test -", () {
  //   testWidgets("test sign in with password", (tester) async {
  //     await tester.pumpWidget(login);

  //     final emailTextField = find.widgetWithText(TextFormField, "Email");
  //     final passwordTextField = find.widgetWithText(TextFormField, "Password");
  //     final signInButton = find.widgetWithText(GradientButton, "Sign In");

  //     expect(emailTextField, findsOneWidget);
  //     expect(passwordTextField, findsOneWidget);
  //     expect(signInButton, findsOneWidget);

  //     await tester.enterText(emailTextField, "test@test.test");
  //     await tester.enterText(passwordTextField, "testPassword1234");

  //     await tester.tap(signInButton);
  //     await tester.pump();
  //   });
  // });
}
