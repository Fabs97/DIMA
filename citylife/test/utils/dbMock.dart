import 'dart:convert';

import 'package:citylife/models/cl_user.dart';
import 'package:http/http.dart' show Response;
import 'package:http/testing.dart';

class DBMock {
  static final userWithoutId = CLUser(
      firebaseId: "testFirebaseId",
      tech: false,
      name: "Fabrizio Casali",
      exp: 200,
      email: "test@test.test",
      password: "testingTheTest");
  static final userWithId = CLUser(
      id: 1,
      firebaseId: "testFirebaseId",
      tech: false,
      name: "Fabrizio Casali",
      exp: 200,
      email: "test@test.test",
      password: "testingTheTest");

  static MockClient userMockClient = MockClient((req) async {
    final String path = req.url.path;

    if (path.contains("/new")) {
      return Response(jsonEncode(userWithId), 200);
    } else if (path.contains("/byFirebase")) {
      return Response(jsonEncode(userWithId), 200);
    } else {
      return Response("Error in MockClient", 500);
    }
  });
}
