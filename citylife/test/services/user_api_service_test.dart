import 'dart:convert';

import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../utils/model_mocks.dart';
import 'user_api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('/leaderboard', () {
    test('returns a list of CLUsers if the http call completes successfully',
        () async {
      final client = MockClient();
      final leadeboard = List.generate(
        10,
        (index) => MockModel.getUser(
          id: index,
          exp: (index + 1) * 10.0,
        ),
      );
      when(
        client.get(
          Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/leaderboard'),
        ),
      ).thenAnswer(
        (_) async => http.Response(jsonEncode(leadeboard), 200),
      );

      var result = await UserAPIService.route('/leaderboard', client: client);

      expect(result, isList);
      expect(result, everyElement(isA<CLUser>()));

      var previousExp;
      result.forEach((element) {
        if (previousExp == null) {
          previousExp = element.exp;
        } else {
          expect(element.exp, greaterThanOrEqualTo(previousExp));
        }
      });
    });
    test('throws a [UserAPIException] if the statusCode is not 200', () async {
      final client = MockClient();
      final errorMessage = "There was an error in the leaderboard API call";
      when(
        client.get(
          Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/leaderboard'),
        ),
      ).thenAnswer(
        (_) async => http.Response(errorMessage, 400),
      );

      try {
        await UserAPIService.route("/leaderboard", client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test(
        'throws a [UserAPIException] if the statusCode is not 200 (empty message)',
        () async {
      final client = MockClient();
      when(
        client.get(
          Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/leaderboard'),
        ),
      ).thenAnswer(
        (_) async => http.Response("", 400),
      );

      try {
        await UserAPIService.route("/leaderboard", client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, "Error while retrieving the user leaderboard");
      }
    });
  });
  group('/new', () {
    test(
        'returns a new CLUser, identical to the one that has just been sent, except for the id',
        () async {
      final client = MockClient();
      final userWithId = MockModel.getUser();
      final userWithoudId = MockModel.getUser(noIdRequired: true);
      when(
        client.post(
          Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/new'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userWithoudId.toJson()),
        ),
      ).thenAnswer(
        (_) async => http.Response(jsonEncode(userWithId), 200),
      );

      var result = await UserAPIService.route(
        "/new",
        body: userWithoudId,
        client: client,
      );
      expect(result, isA<CLUser>());
      // * Don't event know if this check is needed
      expect(result, isNotNull);
    });
    test('throws a [UserAPIException] if the statusCode is not 200', () async {
      final userWithoudId = MockModel.getUser(noIdRequired: true);
      final client = MockClient();
      final errorMessage = "There was an error in the new user API call";
      when(
        client.post(
          Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/new'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userWithoudId.toJson()),
        ),
      ).thenAnswer(
        (_) async => http.Response(errorMessage, 404),
      );

      try {
        await UserAPIService.route("/new", body: userWithoudId, client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test(
        "throws a [UserAPIException] if the statusCode is not 200 (empty message)",
        () async {
      final userWithoudId = MockModel.getUser(noIdRequired: true);
      final client = MockClient();
      when(
        client.post(
          Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/new'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userWithoudId.toJson()),
        ),
      ).thenAnswer(
        (_) async => http.Response("", 404),
      );

      try {
        await UserAPIService.route("/new", body: userWithoudId, client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, "Error in User API Service with code 404");
      }
    });
  });
  group('/byFirebase', () {
    test(
        'returns a CLUser with the given firebaseId if the http call completes successfully',
        () async {
      final client = MockClient();
      final firebaseId = "testing_firebase_id";
      final user = MockModel.getUser(firebaseId: firebaseId);
      when(client.get(
        Uri.parse(
            '$APIENDPOINT${UserAPIService.userRoute}/byFirebase/$firebaseId'),
      )).thenAnswer((_) async => http.Response(jsonEncode(user), 200));

      var result = await UserAPIService.route("/byFirebase",
          urlArgs: firebaseId, client: client);

      expect(result, isA<CLUser>());
      expect(result.firebaseId, equals(firebaseId));
    });
    test('throws a [UserAPIException] if the status code is not 200', () async {
      final client = MockClient();
      final firebaseId = "testing_firebase_id";
      final errorMessage = "There was an error in the new user API call";

      when(client.get(
        Uri.parse(
            '$APIENDPOINT${UserAPIService.userRoute}/byFirebase/$firebaseId'),
      )).thenAnswer((_) async => http.Response(errorMessage, 400));
      try {
        await UserAPIService.route("/byFirebase",
            urlArgs: firebaseId, client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test(
        'throws a [UserAPIException] if the status code is not 200 (empty message)',
        () async {
      final client = MockClient();
      final firebaseId = "testing_firebase_id";

      when(client.get(
        Uri.parse(
            '$APIENDPOINT${UserAPIService.userRoute}/byFirebase/$firebaseId'),
      )).thenAnswer((_) async => http.Response("", 400));
      try {
        await UserAPIService.route("/byFirebase",
            urlArgs: firebaseId, client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, "Error in User API Service with code 400");
      }
    });
  });
  group('/update', () {
    final user = MockModel.getUser();
    test(
        'returns a CLUser identical to the one sent if the http call completes successfully',
        () async {
      final client = MockClient();
      when(client.post(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/update'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      )).thenAnswer((_) async => http.Response(jsonEncode(user), 200));

      var result =
          await UserAPIService.route("/update", body: user, client: client);

      expect(result, isA<CLUser>());
      expect(result, equals(user));
    });
    test('throws a [UserAPIException] if the status code is not 200', () async {
      final client = MockClient();
      final errorMessage = "There was an error in the new user API call";

      when(client.post(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/update'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      )).thenAnswer((_) async => http.Response(errorMessage, 400));
      try {
        await UserAPIService.route("/update", body: user, client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test(
        'throws a [UserAPIException] if the status code is not 200 (empty message)',
        () async {
      final client = MockClient();

      when(client.post(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/update'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      )).thenAnswer((_) async => http.Response("", 400));
      try {
        await UserAPIService.route("/update", body: user, client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, "Error in User API Service with code 400");
      }
    });
  });
  group('/2fa/getSecret', () {
    test(
        "returns a [String] containing the secret for the 2FA if the http call completes successfully",
        () async {
      final client = MockClient();
      final userId = 1;
      final secret = "secret";
      when(client.get(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/2fa/$userId'),
      )).thenAnswer((_) async => http.Response(secret, 200));

      var result = await UserAPIService.route("/2fa/getSecret",
          urlArgs: userId, client: client);
      expect(result, isA<String>());
      expect(result, equals(secret));
    });
    test('throws a [UserAPIException] if the status code is not 200', () async {
      final client = MockClient();
      final userId = 1;
      final errorMessage = "There was an error in the new user API call";

      when(client.get(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/2fa/$userId'),
      )).thenAnswer((_) async => http.Response(errorMessage, 400));

      try {
        await UserAPIService.route("/2fa/getSecret",
            urlArgs: userId, client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test(
        'throws a [UserAPIException] if the status code is not 200 (empty message)',
        () async {
      final client = MockClient();
      final userId = 1;

      when(client.get(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/2fa/$userId'),
      )).thenAnswer((_) async => http.Response("", 400));

      try {
        await UserAPIService.route("/2fa/getSecret",
            urlArgs: userId, client: client);
      } catch (e) {
        expect(e, isA<UserAPIException>());
        expect(e.message, "Error in User API Service with code 400");
      }
    });
  });
  group('/2fa/postCode', () {
    final userId = 1;
    final code = "123456";
    test(
        "returns a [bool] to true which specifies that the code is correct for the 2FA if http status code is 200",
        () async {
      final client = MockClient();
      when(client.post(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/2fa/$userId'),
        headers: {
          "x-citylife-code": code,
          "Content-Type": "application/json",
        },
      )).thenAnswer((_) async => http.Response("", 200));

      var result = await UserAPIService.route(
        "/2fa/postCode",
        urlArgs: userId,
        body: code,
        client: client,
      );

      expect(result, isA<bool>());
      expect(result, true);
    });
    test(
        "returns a [bool] to false which specifies that the code is correct for the 2FA if http status code is 401",
        () async {
      final client = MockClient();
      when(client.post(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/2fa/$userId'),
        headers: {
          "x-citylife-code": code,
          "Content-Type": "application/json",
        },
      )).thenAnswer((_) async => http.Response("", 401));

      var result = await UserAPIService.route(
        "/2fa/postCode",
        urlArgs: userId,
        body: code,
        client: client,
      );

      expect(result, isA<bool>());
      expect(result, false);
    });
    test("throws a [UserAPIException] if the status code is not 200 nor 401",
        () async {
      final client = MockClient();
      when(client.post(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/2fa/$userId'),
        headers: {
          "x-citylife-code": code,
          "Content-Type": "application/json",
        },
      )).thenAnswer(
          (_) async => http.Response("Error while posting 2FA code", 404));

      try {
        await UserAPIService.route(
          "/2fa/postCode",
          urlArgs: userId,
          body: code,
          client: client,
        );
      } catch (e) {
        expect(e, isA<UserAPIException>());
      }
    });
    test(
        "throws a [UserAPIException] if the status code is not 200 nor 401 (empty message)",
        () async {
      final client = MockClient();
      when(client.post(
        Uri.parse('$APIENDPOINT${UserAPIService.userRoute}/2fa/$userId'),
        headers: {
          "x-citylife-code": code,
          "Content-Type": "application/json",
        },
      )).thenAnswer((_) async => http.Response("", 404));

      try {
        await UserAPIService.route(
          "/2fa/postCode",
          urlArgs: userId,
          body: code,
          client: client,
        );
      } catch (e) {
        expect(e, isA<UserAPIException>());
      }
    });
  });

  test('default switch throws [UserAPIException]', () async {
    try {
      await UserAPIService.route("errorRoute");
    } catch (e) {
      expect(e, isA<UserAPIException>());
      expect(e.message, "Error in User API Service");
    }
  });
}
