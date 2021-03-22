import 'package:flutter/cupertino.dart';

class ProfileState with ChangeNotifier {
  bool _hasBeenEdited = false;
  bool _techEdited = true;

  String _editedName;

  String get editedName => _editedName;

  set editedName(v) {
    _editedName = v;
    notifyListeners();
  }

  bool get hasBeenEdited => _hasBeenEdited;
  bool get techEdited => _techEdited;

  set hasBeenEdited(v) {
    _hasBeenEdited = v;
    notifyListeners();
  }
  set techEdited(v) {
    _techEdited = v;
    notifyListeners();
  }

  ProfileState(String initialName) {
    _editedName = initialName;
  }
}
