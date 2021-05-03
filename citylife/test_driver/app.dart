import 'package:flutter_driver/driver_extension.dart';
import 'package:citylife/main.dart' as app;
import '../integration_test/mocks/integration_mocks.dart';

main() {
  enableFlutterDriverExtension();
  app.main(
    testSharedPrefService: sharedPrefService,
    testUserAPIService: userAPIService,
    testBadgeAPIService: badgeAPIservice,
    testImpressionsAPIService: impressionAPIService,
    testAuthService: authService,
    testStorageService: storageService,
  );
}
