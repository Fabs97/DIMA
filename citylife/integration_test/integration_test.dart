import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'utils/utils.dart';

main() async {
  final out = new File("integration_test.log").openWrite();

  FlutterDriver d;
  final email = "sicilianofabrizio@gmail.com";
  final pswd = "testpassword";
  setUpAll(() async {
    final String adbPath =
        'C:/Users/User/AppData/Local/Android/Sdk/platform-tools/adb.exe';
    await Process.run(adbPath, [
      'shell',
      'pm',
      'grant',
      'com.casiano.citylife',
      'android.permission.ACCESS_FINE_LOCATION'
    ]);
    await Process.run(adbPath, [
      'shell',
      'pm',
      'grant',
      'com.casiano.citylife',
      'android.permission.INTERNET'
    ]);
    d = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    d?.close();
    out?.close();
  });

  group('Profile integration test -', () {
    final signInButton = find.byValueKey("SignInButton");
    test('test', () async {
      final emailField = find.byValueKey("LoginFormEmail");
      final pswdField = find.byValueKey("LoginFormPswd");
      final profilePageButton = find.byValueKey("BottomBarProfile");
      final impressionPageButton = find.byValueKey("BottomBarImpression");
      final impressionsListPageButton = find.byValueKey("BottomBarList");
      final newImpressionDialog = find.byValueKey("newImpresssionDialog");
      final newStructuralButton = find.byValueKey("NewStructuralButton");
      final newStructuralNextButton =
          find.byValueKey("NewStructuralNextButton");
      final newStructuralComponentField =
          find.byValueKey("NewStructuralComponentField");
      final newStructuralPathologyField =
          find.byValueKey("NewStructuralPathologyField");
      final newStructuralInterventionField =
          find.byValueKey("NewStructuralInterventionField");
      final newImpressionNotesField =
          find.byValueKey("NewImpressionNotesField");
      final newEmotionalButton = find.byValueKey("NewEmotionalButton");
      // final newImpresionSaving = find.byValueKey("NewImpresionSaving");
      final newImpressionSaved = find.byValueKey("NewImpressionSaved");
      final newEmotionalNextButton = find.byValueKey("NewEmotionalNextButton");
      final listViewFinder = find.byType("ListView");
      final logoutButton = find.byValueKey("ProfileSignOut");

      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Starting application");
      expect((await d.checkHealth()).status, HealthStatus.ok);
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Health status is ok");
      out.writeln("${DateTime.now().millisecondsSinceEpoch} | Starting test");

      // Enter email
      await U.delay(1000);
      await d.waitFor(emailField);
      await d.tap(emailField);
      await d.enterText(email);
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Inserted login email $email");

      // Enter password
      await U.delay(1000);
      await d.waitFor(pswdField);
      await d.tap(find.byValueKey("LoginFormPswd"));
      await d.enterText(pswd);
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Inserted login password");

      // Create a new Structural impression
      // Tap for login
      await U.delay(1000);
      out.writeln("${DateTime.now().millisecondsSinceEpoch} | Signing in");
      await d.waitFor(signInButton);
      await d.tap(signInButton);
      out.writeln("${DateTime.now().millisecondsSinceEpoch} | Signed in");

      // Tap for impression modal
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Starting structural impression creation process");
      await U.delay(1000);
      await d.waitFor(impressionPageButton);
      await d.tap(impressionPageButton);
      await d.waitFor(newImpressionDialog);

      await U.delay(500);
      await d.waitFor(newStructuralButton);
      await d.tap(newStructuralButton);

      // Insert new Structural impression field values
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Inserting structural component");
      await U.delay(500);
      await d.waitFor(newStructuralComponentField);
      await d.tap(newStructuralComponentField);
      await d.enterText("Component integration test");

      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Inserting structural pathology");
      await U.delay(500);
      await d.waitFor(newStructuralPathologyField);
      await d.tap(newStructuralPathologyField);
      await d.enterText("Pathology integration test");

      await U.delay(500);
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Inserting structural intervention suggestion");
      await d.waitFor(newStructuralInterventionField);
      await d.tap(newStructuralInterventionField);
      await U.delay(300);
      await d.tap(find.text("Repair"));

      // Go to the next page
      await U.delay(500);
      await d.waitFor(newStructuralNextButton);
      await d.tap(newStructuralNextButton);

      // Fill in the notes, leave images empty
      await U.delay(500);
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Filling in structural notes");
      await d.waitFor(newImpressionNotesField);
      await d.tap(newImpressionNotesField);
      await d.enterText("Notes integration test");

      // Go to next page and wait for correct save
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Saving created structural impression");
      await U.delay(500);
      await d.waitFor(newStructuralNextButton);
      await d.tap(newStructuralNextButton);

      await d.waitFor(newImpressionSaved);
      // Wait for the dialog to pop out
      await U.delay(1000);

      // Create a new Emotional impression
      // Tap for impression modal
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Starting emotional impression creation process");
      await U.delay(1000);
      await d.waitFor(impressionPageButton);
      await d.tap(impressionPageButton);
      await d.waitFor(newImpressionDialog);

      // Tap to create a new Emotional impression
      await U.delay(500);
      await d.waitFor(newEmotionalButton);
      await d.tap(newEmotionalButton);

      // Go to next page
      await U.delay(500);
      await d.waitFor(newEmotionalNextButton);
      await d.tap(newEmotionalNextButton);

      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Filling in emotional notes");
      // Fill in the notes
      await U.delay(500);
      await d.waitFor(newImpressionNotesField);
      await d.tap(newImpressionNotesField);
      await d.enterText("Notes integration test");

      // Go to next page and wait for correct save
      await U.delay(500);
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Saving created emotional impression");
      await d.waitFor(newEmotionalNextButton);
      await d.tap(newEmotionalNextButton);

      await d.waitFor(newImpressionSaved);
      await U.delay(1000);

      // Go to Impressions list

      await d.tap(impressionsListPageButton);
      await d.waitFor(listViewFinder);
      await U.delay(1000);
      final impressionCards = find.descendant(
        of: listViewFinder,
        matching: find.byType("ImpressionCard"),
        firstMatchOnly: true,
      );
      expect(impressionCards.serialize().isNotEmpty, true);
      expect(impressionCards.serialize().length > 2, true);
      out.writeln(
          "${DateTime.now().millisecondsSinceEpoch} | Expecting more than two impressions has been validated");

      // Go to Profile
      await U.delay(1000);
      await d.waitFor(profilePageButton);
      await d.tap(profilePageButton);
      // Logout
      await U.delay(1000);
      await d.waitFor(logoutButton);
      await d.tap(logoutButton);

      await U.delay(1000);
    });
  });
}
