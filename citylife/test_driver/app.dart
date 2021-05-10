import 'dart:io';

import 'package:flutter_driver/driver_extension.dart';
import 'package:citylife/main.dart' as app;

main() async {
  enableFlutterDriverExtension();
  app.main();
}
