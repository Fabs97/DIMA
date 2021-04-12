import 'dart:convert';

import 'package:citylife/models/cl_user.dart';
import 'package:citylife/utils/constants.dart';
import 'package:http/http.dart' show Client, Response;

class UserAPIService {
  static final String _userRoute = "/user";
  static Client _client;

  static Future<dynamic> route(String subRoute,
      {dynamic body, dynamic urlArgs, Client client}) {
    _client = client ?? new Client();
    switch (subRoute) {
      case "/leaderboard":
        return _getLeaderboard(subRoute);
      case "/new":
        return _postNewUser(subRoute, body);
      case "/byFirebase":
        return _getByFirebaseId(subRoute, urlArgs);
      case "/update":
        return _postUserUpdate(subRoute, body);
      case "/2fa/getSecret":
        return _getSecret(urlArgs);
      case "/2fa/postCode":
        return _postCode(urlArgs, body);
      default:
        throw UserAPIException("Error in User API Service");
    }
  }

  static Future<List<CLUser>> _getLeaderboard(String subRoute) async {
    Response response = await _client.get(
      Uri.parse(APIENDPOINT + _userRoute + subRoute),
    );

    switch (response.statusCode) {
      case 200:
        {
          var body = jsonDecode(response.body);
          return body.map((e) => CLUser.fromJson(e)).toList().cast<CLUser>();
        }
      default:
        throw new UserAPIException(
            response.body ?? "Error while retrieving the user leaderboard");
    }
  }

  static Future<bool> _postCode(int userId, String code) async {
    Response response = await _client.post(
      Uri.parse(APIENDPOINT + _userRoute + "/2fa/$userId"),
      headers: {
        "x-citylife-code": code,
        "Content-Type": "application/json",
      },
    );

    switch (response.statusCode) {
      case 200:
        return true;
      case 401:
        return false;
      default:
        throw new UserAPIException(response.body?.toString() ??
            "Error in User API Service with code ${response.statusCode}");
    }
  }

  static Future<String> _getSecret(int userId) async {
    Response response = await _client.get(
      Uri.parse(APIENDPOINT + _userRoute + "/2fa/$userId"),
    );

    switch (response.statusCode) {
      case 200:
        return response.body;
      default:
        throw new UserAPIException(response.body?.toString() ??
            "Error in User API Service with code ${response.statusCode}");
    }
  }

  static Future<CLUser> _postNewUser(String subRoute, CLUser user) async {
    Response response = await _client.post(
      Uri.parse(APIENDPOINT + _userRoute + subRoute),
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

  static Future<CLUser> _getByFirebaseId(
      String subRoute, String firebaseId) async {
    Response response = await _client.get(
      Uri.parse(APIENDPOINT + _userRoute + subRoute + "/$firebaseId"),
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

  static Future<CLUser> _postUserUpdate(String subRoute, CLUser user) async {
    Response response = await _client.post(
      Uri.parse(APIENDPOINT + _userRoute + subRoute),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    switch (response.statusCode) {
      case 200:
        return CLUser.fromJson(jsonDecode(response.body.toString()));
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
