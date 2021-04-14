import 'dart:convert';

import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/shared_pref_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/shared_pref_service_mock.dart';
import '../utils/model_mocks.dart';

main() async {
  final sharedPreferences = MockSharedPreferences();
  final sharedPrefService = await SharedPrefService.getInstance(
    sharedPreferences: sharedPreferences,
  );
  var key = "TEST_KEY";
  var user = MockModel.getUser();
  var userString = jsonEncode(user.toJson());
  group('getUserBy', () {
    test('returns a [CLUser] if the key is found in the storage', () {
      when(sharedPreferences.get(key)).thenReturn(userString);
      var result = sharedPrefService.getUserBy(key);

      expect(result, isA<CLUser>());
      expect(result, user);
    });
    test('returns null if the key is not found in the storage', () {
      when(sharedPreferences.get(key)).thenReturn(null);
      var result = sharedPrefService.getUserBy(key);

      expect(result, isNull);
    });
  });
  group('setUserWith', () {
    test(
        'returns a [bool] if it was possible to save the provided [CLUser] to the storage',
        () {
      [true, false].forEach((answer) async {
        when(sharedPreferences.setString(key, userString))
            .thenAnswer((_) async => answer);
        var result = await sharedPrefService.setUserWith(key, user);

        expect(result, isA<bool>());
        expect(result, answer);
      });
    });
    test(
        'returns a [bool] false if the [SharedPreferences] storage threw an [Exception]',
        () async {
      when(sharedPreferences.setString(key, userString))
          .thenThrow(Exception("Test Exception"));
      var result = await sharedPrefService.setUserWith(key, user);
      expect(result, isA<bool>());
      expect(result, false);
    });
  });
  group('deleteByKey', () {
    test(
        'returns a [bool] if it was possible to delete the provided [CLUser] from the storage',
        () {
      [true, false].forEach((answer) async {
        when(sharedPreferences.remove(key)).thenAnswer((_) async => answer);
        var result = await sharedPrefService.deleteByKey(key);

        expect(result, isA<bool>());
        expect(result, answer);
      });
    });
    test(
        'returns a [bool] false if the [SharedPreferences] storage threw an [Exception]',
        () async {
      when(sharedPreferences.remove(key))
          .thenThrow(Exception("Test Exception"));
      var result = await sharedPrefService.deleteByKey(key);
      expect(result, isA<bool>());
      expect(result, false);
    });
  });
}
