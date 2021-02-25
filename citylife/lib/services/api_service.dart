import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:http/http.dart' as http;

enum ENDPOINTS {
  // add a new endpoint for each new high-level API Service you create
  User,
  Impression,
}

class APIInfo {
  // Here will be contained all the information for the correct API calls

  // This endpoint is set at compile time when executing the flutter buil/run command.
  // TODO: release build must implement the API_ENDPOINT env variable
  static const apiEndpoint = String.fromEnvironment('API_ENDPOINT',
      defaultValue: "http://10.0.2.2:3000");
}

class APIService {
  static http.Client _client;

  // This is the first layer of the API Service, when adding the second layer of your API call,
  // create a file inside the services/api_services folder and add the route to the ENDPOINTS enum
  static Future<dynamic> route(ENDPOINTS endpoint, String subRoute,
      {dynamic body, dynamic urlArgs, http.Client client}) {
    if (client == null && _client == null)
      _client = http.Client();
    else if (client != null) _client = client;

    try {
      switch (endpoint) {
        case ENDPOINTS.User:
          return UserAPIService.route(subRoute,
              body: body, urlArgs: urlArgs, client: client);
        default:
          throw APIException();
      }
    } catch (e) {
      print("[Error]::APIService - ${e.toString()}");
      return null;
    }
  }
}

class APIException implements Exception {}
