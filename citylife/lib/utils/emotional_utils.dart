import 'package:flutter/material.dart';

class EUtils {
  static IconData getFrom(int val) {
    switch (val) {
      case 1:
        return Icons.sentiment_very_dissatisfied;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 4:
        return Icons.sentiment_satisfied_alt;
      case 5:
        return Icons.sentiment_very_satisfied;
      default:
        throw Exception("Value not defined in emotional range");
    }
  }
}
