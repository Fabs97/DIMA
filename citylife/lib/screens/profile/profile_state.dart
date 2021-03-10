import 'package:flutter/cupertino.dart';

class ProfileState with ChangeNotifier {
  bool _hasBeenEdited = false;

  String _editedName;

  String get editedName => _editedName;

  set editedName(v) {
    _editedName = v;
    notifyListeners();
  }

  bool get hasBeenEdited => _hasBeenEdited;

  set hasBeenEdited(v) {
    _hasBeenEdited = v;
    notifyListeners();
  }

  ProfileState(String initialName) {
    _editedName = initialName;
  }
}
