import 'dart:convert';

import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

main() {
  group("POST new User call", () {
    final String route = "/new";
    final userSent = CLUser(
        firebaseId: "testFirebaseId",
        tech: false,
        name: "Fabrizio Casali",
        exp: 200,
        email: "test@test.test",
        password: "testingTheTest");
    test("returns a CLUser if the response code is 200", () async {
      final userReceived = userSent;
      userReceived.id = 1;

      final mockClient = MockClient((request) async {
        return Response(jsonEncode(userReceived), 200);
      });
      dynamic result =
          await UserAPIService.route(route, body: userSent, client: mockClient);
      expect(result, isA<CLUser>());
    });
    test("Throws an Exception if 404 as response", () {
      final mockClient = MockClient((req) async {
        return Response("Testing 404", 404);
      });

      expect(
          () async => await UserAPIService.route(route,
              body: userSent, client: mockClient),
          throwsA(predicate((e) => e is UserAPIException)));
    });

    test("Throws an Exception if 500 as response", () {
      final mockClient = MockClient((req) async {
        return Response("Testing 500", 500);
      });

      expect(
          () async => await UserAPIService.route(route,
              body: userSent, client: mockClient),
          throwsA(predicate((e) => e is UserAPIException)));
    });
  });

  group("GET by FirebaseId", () {
    final String route = "/byFirebase";
    final user = CLUser(
        id: 2,
        firebaseId: "testFirebaseId",
        tech: false,
        name: "Fabrizio Casali",
        exp: 200,
        email: "test@test.test",
        password: "testingTheTest");
    test("returns a CLUser if the response code is 200", () async {
      final mockClient = MockClient((request) async {
        return Response(jsonEncode(user), 200);
      });
      dynamic result = await UserAPIService.route(route,
          urlArgs: "testFirebaseId", client: mockClient);
      expect(result, isA<CLUser>());
    });

    test("Throws an Exception if 404 as response", () {
      final mockClient = MockClient((req) async {
        return Response("Testing 404", 404);
      });

      expect(
          () async => await UserAPIService.route(route,
              urlArgs: "testFirebaseUserId", client: mockClient),
          throwsA(predicate((e) => e is UserAPIException)));
    });

    test("Throws an Exception if 500 as response", () {
      final mockClient = MockClient((req) async {
        return Response("Testing 500", 500);
      });

      expect(
          () async => await UserAPIService.route(route,
              urlArgs: "testFirebaseUserId", client: mockClient),
          throwsA(predicate((e) => e is UserAPIException)));
    });
  });

  group("Other Tests - ", () {
    test("defaul switch route option", () {
      expect(
          () async => await UserAPIService.route("testDefaultRoute"),
          throwsA(predicate((e) =>
              e is UserAPIException &&
              e.message.compareTo("Error in User API Service") == 0)));
    });
  });
}
