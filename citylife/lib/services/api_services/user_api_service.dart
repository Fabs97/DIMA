import 'dart:convert';

import 'package:citylife/models/cl_user.dart';
import 'package:citylife/utils/constants.dart';
import 'package:http/http.dart' show Client, Response;

class UserAPIService {
  static final String userRoute = "/user";
  static Client _client;

  static Future<dynamic> route(String subRoute,
      {dynamic body, dynamic urlArgs, Client client}) {
    _client = client ?? new Client();
    switch (subRoute) {
      case "/new":
        return _postNewUser(subRoute, body);
      case "/byFirebase":
        return _getByFirebaseId(subRoute, urlArgs);
      case "/update":
        return _postUserUpdate(subRoute, body);
      default:
        throw UserAPIException("Error in User API Service");
    }
  }

  static Future<CLUser> _postNewUser(String subRoute, CLUser user) async {
    Response response = await _client.post(
      APIENDPOINT + userRoute + subRoute,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    switch (response.statusCode) {
      case 200:
        return CLUser.fromJson(jsonDecode(response.body));
      case 404:
      case 500:
      default:
        throw new UserAPIException(
            response.body?.toString() ??
            "Error in User API Service with code ${response.statusCode}");
    }
  }

  static Future<CLUser> _getByFirebaseId(
      String subRoute, String firebaseId) async {
    Response response = await _client.get(
      APIENDPOINT + userRoute + subRoute + "/$firebaseId",
    );

    switch (response.statusCode) {
      case 200:
        return CLUser.fromJson(jsonDecode(response.body));
      case 404:
      case 500:
      default:
        throw new UserAPIException(
            response.body?.toString() ??
            "Error in User API Service with code ${response.statusCode}");
    }
  }

  static Future<CLUser> _postUserUpdate(String subRoute, CLUser user) async {
    Response response = await _client.post(
      APIENDPOINT + userRoute + subRoute,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    switch (response.statusCode) {
      case 200:
        return CLUser.fromJson(jsonDecode(response.body));
      case 404:
      case 500:
      default:
        throw new UserAPIException(response.body?.toString() ??
            "Error in User API Service with code ${response.statusCode}");
    }
  }
}

class UserAPIException implements Exception {
  final String message;

  UserAPIException(this.message);
}
