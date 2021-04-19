import 'dart:convert';

import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/screens/map_impressions/map_impressions.dart';
import 'package:citylife/utils/constants.dart';
import 'package:http/http.dart' show Client, Response;

class ImpressionsAPIService {
  static final String impressionRoute = "/impression";
  Client _client;

  Future<dynamic> route(String subRoute,
      {dynamic body, dynamic urlArgs, Client client}) {
    _client = client ?? new Client();
    switch (subRoute) {
      case "/byUser":
        return _getImpressions(subRoute, urlArgs);
      case "/byLatLong":
        return _getImpressionsByLatLong(subRoute, urlArgs);
      case "/emotional":
      case "/structural":
        return _deleteImpression(subRoute, urlArgs);
      case "/new":
        return _postImpression(subRoute, body);
      default:
        throw ImpressionsAPIException("Error in Impressions API Service");
    }
  }

  Future<List<CLImpression>> _deleteImpression(
      String subRoute, int id) async {
    Response response = await _client.delete(
      Uri.parse(APIENDPOINT + impressionRoute + subRoute + "/$id"),
    );

    switch (response.statusCode) {
      case 200:
        return _parseImpressionsJson(response.body);
      default:
        throw new ImpressionsAPIException((response.body != null &&
                    response.body.isNotEmpty
                ? response.body
                : null) ??
            "Error in Impression API Service with code ${response.statusCode}");
    }
  }

  Future<List<CLImpression>> _getImpressionsByLatLong(
      String subRoute, HomeArguments args) async {
    Response response = await _client.get(
      Uri.parse(APIENDPOINT +
          impressionRoute +
          subRoute +
          "/${args.latMin}" +
          "/${args.latMax}" +
          "/${args.longMin}" +
          "/${args.longMax}"),
    );

    switch (response.statusCode) {
      case 200:
        return _parseImpressionsJson(response.body);
      default:
        throw new ImpressionsAPIException((response.body != null &&
                    response.body.isNotEmpty
                ? response.body
                : null) ??
            "Error in Impression API Service with code ${response.statusCode}");
    }
  }

  Future<List<CLImpression>> _getImpressions(
      String subRoute, int id) async {
    Response response = await _client.get(
      Uri.parse(APIENDPOINT + impressionRoute + subRoute + "/$id"),
    );

    switch (response.statusCode) {
      case 200:
        return _parseImpressionsJson(response.body);
      default:
        throw new ImpressionsAPIException((response.body != null &&
                    response.body.isNotEmpty
                ? response.body
                : null) ??
            "Error in Impression API Service with code ${response.statusCode}");
    }
  }

  Future<CLImpression> _postImpression(
      String subRoute, CLImpression impression) async {
    Response response = await _client.post(
      Uri.parse(APIENDPOINT +
          impressionRoute +
          "${impression is CLStructural ? "/structural" : "/emotional"}" +
          subRoute),
      headers: {"Content-Type": "application/json"},
      body: impression.toJson(),
    );
    switch (response.statusCode) {
      case 200:
        return _parseImpression(jsonDecode(response.body));
      default:
        throw new ImpressionsAPIException((response.body != null &&
                    response.body.isNotEmpty
                ? response.body
                : null) ??
            "Error in Impression API Service with code ${response.statusCode}");
    }
  }

  List<CLImpression> _parseImpressionsJson(String json) {
    final parsed = jsonDecode(json);
    return List.from(parsed.map((e) => _parseImpression(e)));
  }

  CLImpression _parseImpression(Object impression) {
    Map<String, dynamic> i =
        impression is String ? jsonDecode(impression) : impression;
    if (i.keys.contains("component") ||
        i.keys.contains("pathology") ||
        i.keys.contains("typology")) {
      return CLStructural.fromJson(i);
    } else
      return CLEmotional.fromJson(i);
  }
}

class ImpressionsAPIException implements Exception {
  final String message;

  ImpressionsAPIException(this.message);
}
