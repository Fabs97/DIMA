import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

main() {
  FlutterDriver d;
  setUpAll(() async {
    d = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    d?.close();
  });

  group('Profile integration test -', () {
    test('test', () async {
      expect((await d.checkHealth()).status, HealthStatus.ok);
    });
  });
}
