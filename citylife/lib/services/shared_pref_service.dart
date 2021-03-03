import 'dart:async';
import 'dart:convert';

import 'package:citylife/models/cl_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPrefService _instance;
  static SharedPreferences _preferences;

  static Future<SharedPrefService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPrefService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  String getStringBy(String key) {
    return _getByKey(key) as String;
  }

  CLUser getUserBy(String key) {
    String userStringFromSP = _getByKey(key);
    if (userStringFromSP != null) {
      Map<String, dynamic> userJson = jsonDecode(userStringFromSP);
      return CLUser.fromJson(userJson);
    } else
      return null;
  }

  Future<bool> setUserWith(String key, CLUser user) async {
    try {
      String userString = jsonEncode(user.toJson());
      return await _setStringWithKey(key, userString);
    } catch (e, sTrace) {
      print("[SharedPrefService]::setUserWith - $e\n$sTrace");
      return false;
    }
  }

  Future<bool> deleteByKey(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (e, sTrace) {
      print("[SharedPrefService]::deleteByKey - $e\n$sTrace");
      return false;
    }
  }

  dynamic _getByKey(String key) {
    return _preferences.get(key);
  }

  Future<bool> _setStringWithKey(String key, String value) async {
    return await _preferences.setString(key, value);
  }
}
