import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:logger/logger.dart';

import 'utils/utils.dart';

class CustomOutput extends LogOutput {
  final out = File("./output.log");
  @override
  void output(OutputEvent event) {
    out.writeAsStringSync(event.lines.join("\n"));
  }
}


main() async {
  final logger = Logger(
    output: CustomOutput(),
    printer: PrettyPrinter(
      methodCount: 2,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

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
  });

  group('Profile integration test -', () {
    final signInButton = find.byValueKey("SignInButton");
    test('test', () async {
      final newBadgeDialogKey = "NewBadgeDialog";

      final emailField = find.byValueKey("LoginFormEmail");
      final pswdField = find.byValueKey("LoginFormPswd");
      final profilePageButton = find.byValueKey("BottomBarProfile");
      final impressionPageButton = find.byValueKey("BottomBarImpression");
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
      final newImpresionSavingError =
          find.byValueKey("NewImpresionSavingError");
      final newImpressionSaved = find.byValueKey("NewImpressionSaved");
      final newEmotionalCleannessSliderKey = "NewEmotionalCleannessSlider";
      final newEmotionalHappinessSliderKey = "NewEmotionalHappinessSlider";
      final newEmotionalInclusivenessSliderKey =
          "NewEmotionalInclusivenessSlider";
      final newEmotionalComfortSliderKey = "NewEmotionalComfortSlider";
      final newEmotionalSafetySliderKey = "NewEmotionalSafetySlider";
      final newEmotionalNextButton = find.byValueKey("NewEmotionalNextButton");
      final logoutButton = find.byValueKey("ProfileSignOut");

      logger.i("Starting application");
      expect((await d.checkHealth()).status, HealthStatus.ok);
      logger.i("Health status is ok");
      logger.i("Starting test");

      // Enter email
      await U.delay(1000);
      await d.waitFor(emailField);
      await d.tap(emailField);
      await d.enterText(email);
      logger.i("Inserted login email $email");

      // Enter password
      await U.delay(1000);
      await d.waitFor(pswdField);
      await d.tap(find.byValueKey("LoginFormPswd"));
      await d.enterText(pswd);
      logger.i("Inserted login password");

      // Create a new Structural impression
      // Tap for login
      await U.delay(1000);
      logger.i("Signing in");
      await d.waitFor(signInButton);
      await d.tap(signInButton);
      logger.i("Signed in");

      // Tap for impression modal
      logger.i("Starting structural impression creation process");
      await U.delay(1000);
      await d.waitFor(impressionPageButton);
      await d.tap(impressionPageButton);
      await d.waitFor(newImpressionDialog);

      await U.delay(500);
      await d.waitFor(newStructuralButton);
      await d.tap(newStructuralButton);

      // Insert new Structural impression field values
      logger.i("Inserting structural component");
      await U.delay(500);
      await d.waitFor(newStructuralComponentField);
      await d.tap(newStructuralComponentField);
      await d.enterText("Component integration test");

      logger.i("Inserting structural pathology");
      await U.delay(500);
      await d.waitFor(newStructuralPathologyField);
      await d.tap(newStructuralPathologyField);
      await d.enterText("Pathology integration test");

      await U.delay(500);
      logger.i("Inserting structural intervention suggestion");
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
      logger.i("Filling in structural notes");
      await d.waitFor(newImpressionNotesField);
      await d.tap(newImpressionNotesField);
      await d.enterText("Notes integration test");

      // Go to next page and wait for correct save
      logger.i("Saving created structural impression");
      await U.delay(500);
      await d.waitFor(newStructuralNextButton);
      await d.tap(newStructuralNextButton);

      await d.waitFor(newImpressionSaved);
      // Wait for the dialog to pop out
      await U.delay(1000);
      // if (find.byValueKey(newBadgeDialogKey).serialize().isNotEmpty) {
      //   await d.tap(find.byValueKey(newBadgeDialogKey));
      // }

      // Create a new Emotional impression
      // Tap for impression modal
      logger.i("Starting emotional impression creation process");
      await U.delay(1000);
      await d.waitFor(impressionPageButton);
      await d.tap(impressionPageButton);
      await d.waitFor(newImpressionDialog);

      // Tap to create a new Emotional impression
      await U.delay(500);
      await d.waitFor(newEmotionalButton);
      await d.tap(newEmotionalButton);

      logger.i("Sliding cleanness slider");
      await U.delay(200);
      expect(find.byValueKey(newEmotionalCleannessSliderKey), isNotNull);
      await d.scroll(find.byValueKey(newEmotionalCleannessSliderKey), 150, 0,
          Duration(milliseconds: 300));

      logger.i("Sliding happiness slider");
      await U.delay(200);
      expect(find.byValueKey(newEmotionalHappinessSliderKey), isNotNull);
      await d.scroll(find.byValueKey(newEmotionalHappinessSliderKey), 150, 0,
          Duration(milliseconds: 300));

      logger.i("Sliding inclusiveness slider");
      await U.delay(200);
      expect(find.byValueKey(newEmotionalInclusivenessSliderKey), isNotNull);
      await d.scroll(find.byValueKey(newEmotionalInclusivenessSliderKey), 150,
          0, Duration(milliseconds: 300));

      await U.delay(200);
      logger.i("Sliding comfort slider");
      expect(find.byValueKey(newEmotionalComfortSliderKey), isNotNull);
      await d.scroll(find.byValueKey(newEmotionalComfortSliderKey), 150, 0,
          Duration(milliseconds: 300));

      await U.delay(200);
      logger.i("Sliding safety slider");
      expect(find.byValueKey(newEmotionalSafetySliderKey), isNotNull);
      await d.scroll(find.byValueKey(newEmotionalSafetySliderKey), 150, 0,
          Duration(milliseconds: 300));

      // Go to next page
      await U.delay(500);
      await d.waitFor(newEmotionalNextButton);
      await d.tap(newEmotionalNextButton);

      logger.i("Filling in emotional notes");
      // Fill in the notes
      await U.delay(500);
      await d.waitFor(newImpressionNotesField);
      await d.tap(newImpressionNotesField);
      await d.enterText("Notes integration test");

      // Go to next page and wait for correct save
      await U.delay(500);
      logger.i("Saving created emotional impression");
      await d.waitFor(newEmotionalNextButton);
      await d.tap(newEmotionalNextButton);

      await d.waitFor(newImpressionSaved);

      await U.delay(1000);
      if (find.byValueKey(newBadgeDialogKey) != null) {
        await d.tap(find.byValueKey(newBadgeDialogKey));
      }

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
