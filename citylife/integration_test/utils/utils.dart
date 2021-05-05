class U {
  static Future<void> delay([duration = 250]) {
    return Future.delayed(Duration(milliseconds: duration));
  }
}
