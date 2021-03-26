import 'dart:convert';

import 'package:citylife/models/cl_badges.dart';
import 'package:citylife/utils/constants.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:path/path.dart';

class BadgeAPIService {
  static final String _badgeRoute = "/badge";
  static Client _client;

  static Future<dynamic> route(String subRoute,
      {dynamic body, dynamic urlArgs, Client client}) {
    _client = client ?? new Client();
    switch (subRoute) {
      case "/by":
        return _getBadge(subRoute, urlArgs);
      case "/login":
        return _postLoginBadge(urlArgs);
      case "/techie":
        return _postTechieBadge(subRoute, urlArgs);
      case "/impression/emotional":
        return _postImpressionBadge(subRoute, urlArgs, true);
      case "/impression/structural":
        return _postImpressionBadge(subRoute, urlArgs, false);
      default:
        throw BadgeAPIException("Error in Badge API Service");
    }
  }

  static Future<CLBadge> _getBadge(String subRoute, int userId) async {
    Response response =
        await _client.get(APIENDPOINT + _badgeRoute + subRoute + "/$userId");
    switch (response.statusCode) {
      case 200:
        return CLBadge.fromJson(jsonDecode(response.body));
      default:
        throw new BadgeAPIException(response.body ??
            "Error while retrieving the badges of user $userId");
    }
  }

  static Future<Badge> _postTechieBadge(String subRoute, int userId) async {
    Response response =
        await _client.post(APIENDPOINT + _badgeRoute + subRoute + "/$userId");
    if (response.statusCode >= 300) {
      throw BadgeAPIException(response.body ?? "Error in the postLoginBadge");
    } else {
      return Badge.Techie;
    }
  }

  static Future<Badge> _postImpressionBadge(
      String subRoute, int userId, bool isEmotional) async {
    Response response =
        await _client.post(APIENDPOINT + _badgeRoute + subRoute + "/$userId");
    if (response.statusCode >= 300) {
      throw BadgeAPIException(response.body ?? "Error in the postLoginBadge");
    } else {
      switch (response.body) {
        case "\"structural_1\"":
          return Badge.Structural1;
        case "\"structural_5\"":
          return Badge.Structural5;
        case "\"structural_10\"":
          return Badge.Structural10;
        case "\"structural_25\"":
          return Badge.Structural25;
        case "\"structural_50\"":
          return Badge.Structural50;
        case "\"emotional_1\"":
          return Badge.Emotional1;
        case "\"emotional_5\"":
          return Badge.Emotional5;
        case "\"emotional_10\"":
          return Badge.Emotional10;
        case "\"emotional_25\"":
          return Badge.Emotional25;
        case "\"emotional_50\"":
          return Badge.Emotional50;
        default:
          return null;
      }
    }
  }

  static Future<Badge> _postLoginBadge(int userId) async {
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
