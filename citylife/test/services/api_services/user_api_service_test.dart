import 'dart:convert';

import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import '../../utils/dbMock.dart';

main() {
  group("POST new User call -", () {
    final String route = "/new";

    test("returns a CLUser if the response code is 200", () async {
      dynamic result =
          await UserAPIService.route(route,
          body: DBMock.userWithoutId, client: DBMock.userMockClient);
      expect(result, isA<CLUser>());
    });
    test("Throws an Exception if 404 as response", () {
      final mockClient = MockClient((req) async {
        return Response("Testing 404", 404);
      });

      expect(
          () async => await UserAPIService.route(route,
              body: DBMock.userWithoutId, client: mockClient),
          throwsA(predicate((e) => e is UserAPIException)));
    });

    test("Throws an Exception if 500 as response", () {
      final mockClient = MockClient((req) async {
        return Response("Testing 500", 500);
      });

      expect(
          () async => await UserAPIService.route(route,
              body: DBMock.userWithoutId, client: mockClient),
          throwsA(predicate((e) => e is UserAPIException)));
    });
  });

  group("GET by FirebaseId -", () {
    final String route = "/byFirebase";
    test("returns a CLUser if the response code is 200", () async {

      dynamic result = await UserAPIService.route(route,
          urlArgs: "testFirebaseId", client: DBMock.userMockClient);
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

  group("Other Tests -", () {
    test("default switch route option", () {
      expect(
          () async => await UserAPIService.route("testDefaultRoute"),
          throwsA(predicate((e) =>
              e is UserAPIException &&
              e.message.compareTo("Error in User API Service") == 0)));
    });
  });
}
