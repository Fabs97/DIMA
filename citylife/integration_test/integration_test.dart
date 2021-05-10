import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'utils/utils.dart';

main() async {
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
      expect((await d.checkHealth()).status, HealthStatus.ok);

      final emailField = find.byValueKey("LoginFormEmail");
      final pswdField = find.byValueKey("LoginFormPswd");
      final profilePageButton = find.byValueKey("BottomBarProfile");
      final logoutButton = find.byValueKey("ProfileSignOut");

      // Enter email
      await U.delay(1000);
      await d.waitFor(emailField);
      await d.tap(emailField);
      await d.enterText(email);

      // Enter password
      await U.delay(1000);
      await d.waitFor(pswdField);
      await d.tap(find.byValueKey("LoginFormPswd"));
      await d.enterText(pswd);

      // Tap for login
      await U.delay(1000);
      await d.waitFor(signInButton);
      await d.tap(signInButton);

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
