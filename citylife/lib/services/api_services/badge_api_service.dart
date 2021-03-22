import 'package:citylife/utils/constants.dart';
import 'package:http/http.dart' show Client, Response;

class BadgeAPIService {
  static final String _badgeRoute = "/badge";
  static Client _client;

  static Future<dynamic> route(String subRoute,
      {dynamic body, dynamic urlArgs, Client client}) {
    _client = client ?? new Client();
    switch (subRoute) {
      case "/login":
        return _postLoginBadge(urlArgs);
      default:
        throw BadgeAPIException("Error in Badge API Service");
    }
  }

  static Future<Badge> _postLoginBadge(userId) async {
    Response response =
        await _client.post(APIENDPOINT + _badgeRoute + "/login/$userId");
    if (response.statusCode >= 300) {
      throw BadgeAPIException(response.body ?? "Error in the postLoginBadge");
    } else {
      switch (response.body) {
        case "\"daily_3\"":
          return Badge.Daily3;
        case "\"daily_5\"":
          return Badge.Daily5;
        case "\"daily_10\"":
          return Badge.Daily10;
        case "\"daily_30\"":
          return Badge.Daily30;
        default:
          return null;
      }
    }
  }
}

class BadgeAPIException implements Exception {
  final String message;

  BadgeAPIException(this.message);
}
