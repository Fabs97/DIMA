import 'dart:convert';

import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_service.dart';
import 'package:http/http.dart' as http;

class UserAPIService {
  static final String userRoute = "/user";
  static http.Client _client;

  static Future<dynamic> route(String subRoute,
      {dynamic body, dynamic urlArgs, http.Client client}) {
    _client = client;
    switch (subRoute) {
      case "/new":
        return _postNewUser(subRoute, body);
      case "/byFirebase":
        return _getByFirebaseId(subRoute, urlArgs);
      default:
        throw UserAPIException("Error in User API Service");
    }
  }

  static Future<CLUser> _postNewUser(String subRoute, CLUser user) async {
    http.Response response = await _client.post(
      APIInfo.apiEndpoint + userRoute + subRoute,
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
            response.body?.toString() ?? "Error in User API Service");
    }
  }

  static Future<CLUser> _getByFirebaseId(
      String subRoute, String firebaseId) async {
    http.Response response = await _client.get(
      APIInfo.apiEndpoint + userRoute + subRoute + "/$firebaseId",
    );

    switch (response.statusCode) {
      case 200:
        return CLUser.fromJson(jsonDecode(response.body));
      case 404:
      case 500:
      default:
        throw new UserAPIException(
            response.body?.toString() ?? "Error in User API Service");
    }
  }
}

class UserAPIException extends APIException {
  final String message;

  UserAPIException(this.message);
}
