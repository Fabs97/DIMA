import 'package:citylife/utils/emotional_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Emotional Impression Utils -', () {
    test('get icon from value', () {
      <int, IconData>{
        1: Icons.sentiment_very_dissatisfied,
        2: Icons.sentiment_dissatisfied,
        3: Icons.sentiment_neutral,
        4: Icons.sentiment_satisfied_alt,
        5: Icons.sentiment_very_satisfied,
      }.forEach((i, iconData) {
        expect(EUtils.getFrom(i), iconData);
      });
    });
    test('get icon from value default error', () {
      expect(() => EUtils.getFrom(0), throwsA(isA<Exception>()));
    });
  });
}
