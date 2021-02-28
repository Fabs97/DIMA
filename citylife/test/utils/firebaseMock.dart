// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:mockito/mockito.dart';

typedef Callback = void Function(MethodCall call);

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements User {}

class MockGithubSignIn extends Mock implements GitHubSignIn {}

class MockGithubAuthProvider extends Mock implements GithubAuthProvider {
  static credential(String test) {}
  MockGithubAuthProvider();
}

// class MockGithubAuthProvider extends Mock implements GithubAuthProvider {}

class MockUserCredential extends Mock implements UserCredential {
  AdditionalUserInfo additionalUserInfo;
  AuthCredential credential;
  User user;

  MockUserCredential({this.additionalUserInfo, this.credential, this.user});
}

class MockUser extends Mock implements User {
  final String uid;

  MockUser({this.uid});
}

void setupFirebaseAuthMocks([Callback customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}
