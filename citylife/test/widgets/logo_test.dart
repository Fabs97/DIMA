import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:citylife/widgets/logo.dart';

main() async {
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
