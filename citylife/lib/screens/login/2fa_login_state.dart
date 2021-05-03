import 'package:flutter/material.dart';

class TwoFALoginState with ChangeNotifier {
  bool _auth = false;

  bool get authenticated => _auth;

  set authenticated(v) {
    _auth = v;
    notifyListeners();
  }
}
