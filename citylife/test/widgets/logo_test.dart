import 'package:citylife/widgets/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("L class", () {
    test(
        "check if all constant values are correct and their types what they're supposed to be",
        () {
      expect(L.CityLife, isA<SvgPicture>());
      expect(L.Google, isA<AssetImage>());
      expect(L.Twitter, isA<AssetImage>());
      expect(L.GitHub, isA<AssetImage>());
      expect(L.Facebook, isA<AssetImage>());
    });
  });
}
