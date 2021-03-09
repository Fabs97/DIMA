import 'dart:convert';

import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/utils/constants.dart';
import 'package:http/http.dart' show Client, Response;

class ImpressionsAPIService {
  static final String impressionRoute = "/impression";
  static Client _client;

  static Future<dynamic> route(String subRoute,
      {dynamic body, dynamic urlArgs, Client client}) {
    _client = client ?? new Client();
    switch (subRoute) {
      case "/byUser":
        return _getImpressions(subRoute, urlArgs);
      case "/emotional":
      case "/structural":
        return _deleteImpression(subRoute, urlArgs);
      default:
        throw ImpressionsAPIException("Error in Impressions API Service");
    }
  }

  static Future<List<CLImpression>> _deleteImpression(
      String subRoute, int id) async {
    Response response = await _client.delete(
      APIENDPOINT + impressionRoute + subRoute + "/$id",
    );

    switch (response.statusCode) {
      case 200:
        return _parseImpressionsJson(response.body);
      default:
        throw new ImpressionsAPIException(response.body?.toString() ??
            "Error in Impression API Service with code ${response.statusCode}");
    }
  }

  static Future<List<CLImpression>> _getImpressions(
      String subRoute, int id) async {
    Response response = await _client.get(
      APIENDPOINT + impressionRoute + subRoute + "/$id",
    );

    switch (response.statusCode) {
      case 200:
        return _parseImpressionsJson(response.body);
      default:
        throw new ImpressionsAPIException(response.body?.toString() ??
            "Error in Impression API Service with code ${response.statusCode}");
    }
  }

  static List<CLImpression> _parseImpressionsJson(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    var res = parsed
        .map((e) {
          if (e.keys.contains("component") ||
              e.keys.contains("pathology") ||
              e.keys.contains("typology")) {
            return CLStructural.fromJson(e);
          } else
            return CLEmotional.fromJson(e);
        })
        .cast<CLImpression>()
        .toList();
    return res;
  }
}

class ImpressionsAPIException implements Exception {
  final String message;

  ImpressionsAPIException(this.message);
}
