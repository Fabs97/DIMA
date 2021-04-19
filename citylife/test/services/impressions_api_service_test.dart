import 'dart:convert';
import 'dart:math';

import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/screens/map_impressions/map_impressions.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../utils/model_mocks.dart';
import 'impressions_api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final errorMessage = "Generic error from the backend";
  final client = MockClient();
  final impressionsAPIService = ImpressionsAPIService();
  final impressions = List.generate(
    10,
    (index) => Random().nextBool()
        ? MockModel.getEmotional(
            id: index,
            userId: index + 1,
          )
        : MockModel.getStructural(
            id: index,
            userId: index + 1,
          ),
  );
  group('/byUser', () {
    final userId = 1;
    test(
        'returns a [List<CLImpression>] if the http call evaluates successfully',
        () async {
      when(client.get(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/byUser/$userId'),
      )).thenAnswer((_) async => http.Response(jsonEncode(impressions), 200));

      var res = await impressionsAPIService.route(
        "/byUser",
        urlArgs: userId,
        client: client,
      );

      expect(res, isList);
      expect(res, everyElement(isA<CLImpression>()));
    });
    test(
        'throws a [ImpressionAPIException] if the http call fails for any reason',
        () async {
      when(client.get(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/byUser/$userId'),
      )).thenAnswer((_) async => http.Response(errorMessage, 400));

      var result;
      try {
        result = await impressionsAPIService.route(
          "/byUser",
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<ImpressionsAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test(
        'throws a [ImpressionAPIException] if the http call fails for any reason (empty message)',
        () async {
      when(client.get(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/byUser/$userId'),
      )).thenAnswer((_) async => http.Response("", 400));

      var result;
      try {
        result = await impressionsAPIService.route(
          "/byUser",
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<ImpressionsAPIException>());
        expect(e.message, "Error in Impression API Service with code 400");
      }
    });
  });
  group('/byLatLong', () {
    final latMin = 10.0;
    final latMax = 10.0;
    final longMin = 10.0;
    final longMax = 10.0;
    test(
        'returns a [List<CLImpression>] if the http call completes successfully',
        () async {
      when(client.get(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/byLatLong/$latMin/$latMax/$longMin/$longMax'),
      )).thenAnswer((_) async => http.Response(jsonEncode(impressions), 200));

      var result = await impressionsAPIService.route(
        "/byLatLong",
        urlArgs: HomeArguments(
          latMin,
          latMax,
          longMin,
          longMax,
        ),
        client: client,
      );
      expect(result, isList);
      expect(result, everyElement(isA<CLImpression>()));
      expect(result, isNotEmpty);
    });
    test('throws an [ImpressionAPIException] if the http call fails', () async {
      when(client.get(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/byLatLong/$latMin/$latMax/$longMin/$longMax'),
      )).thenAnswer((_) async => http.Response(errorMessage, 400));

      var result;
      try {
        result = await impressionsAPIService.route(
          "/byLatLong",
          urlArgs: HomeArguments(
            latMin,
            latMax,
            longMin,
            longMax,
          ),
          client: client,
        );
      } catch (e) {
        expect(e, isA<ImpressionsAPIException>());
        expect(e.message, errorMessage);
        expect(result, isNull);
      }
    });
    test('throws an [ImpressionAPIException] if the http call fails', () async {
      when(client.get(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/byLatLong/$latMin/$latMax/$longMin/$longMax'),
      )).thenAnswer((_) async => http.Response("", 400));

      var result;
      try {
        result = await impressionsAPIService.route(
          "/byLatLong",
          urlArgs: HomeArguments(
            latMin,
            latMax,
            longMin,
            longMax,
          ),
          client: client,
        );
      } catch (e) {
        expect(e, isA<ImpressionsAPIException>());
        expect(e.message, "Error in Impression API Service with code 400");
        expect(result, isNull);
      }
    });
  });
  group('/emotional + /structural', () {
    final impressionId = 1;
    test(
        'returns the updated [List<CLImpression>] when the http call completes successfully',
        () async {
      var impressionsBut1 = List.from(impressions);
      impressionsBut1
          .remove(impressionsBut1.firstWhere((imp) => imp.id == impressionId));
      when(client.delete(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/emotional/$impressionId'),
      )).thenAnswer(
          (_) async => http.Response(jsonEncode(impressionsBut1), 200));

      var result = await impressionsAPIService.route("/emotional",
          urlArgs: impressionId, client: client);

      expect(result, isList);
      expect(result, everyElement(isA<CLImpression>()));
      expect(result.length, equals(impressions.length - 1));
    });
    test('throws an [ImpressionAPIException] if the http call fails', () async {
      when(client.delete(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/structural/$impressionId'),
      )).thenAnswer((_) async => http.Response(errorMessage, 400));

      var result;
      try {
        result = await impressionsAPIService.route(
          '/structural',
          urlArgs: impressionId,
          client: client,
        );
      } catch (e) {
        expect(e, isA<ImpressionsAPIException>());
        expect(e.message, errorMessage);
        expect(result, isNull);
      }
    });
    test(
        'throws an [ImpressionAPIException] if the http call fails (empty message)',
        () async {
      when(client.delete(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/structural/$impressionId'),
      )).thenAnswer((_) async => http.Response("", 400));

      var result;
      try {
        result = await impressionsAPIService.route(
          '/structural',
          urlArgs: impressionId,
          client: client,
        );
      } catch (e) {
        expect(e, isA<ImpressionsAPIException>());
        expect(e.message, "Error in Impression API Service with code 400");
        expect(result, isNull);
      }
    });
  });
  group('/new', () {
    final impression = MockModel.getEmotional();
    test('returns a [CLImpression] if the http call evaluates successfully',
        () async {
      when(client.post(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/emotional/new'),
        headers: {"Content-Type": "application/json"},
        body: impression.toJson(),
      )).thenAnswer((_) async => http.Response(impression.toJson(), 200));

      var result = await impressionsAPIService.route("/new",
          body: impression, client: client);

      expect(result, isA<CLImpression>());
      expect(result, isA<CLEmotional>());
    });
    test('throws an [ImpressionAPIException] if the http call fails', () async {
      when(client.post(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/emotional/new'),
        headers: {"Content-Type": "application/json"},
        body: impression.toJson(),
      )).thenAnswer((_) async => http.Response(errorMessage, 400));

      var result;
      try {
        result = await impressionsAPIService.route("/new",
            body: impression, client: client);
      } catch (e) {
        expect(e, isA<ImpressionsAPIException>());
        expect(e.message, errorMessage);
        expect(result, isNull);
      }
    });
    test('throws an [ImpressionAPIException] if the http call fails', () async {
      when(client.post(
        Uri.parse(
            '$APIENDPOINT${ImpressionsAPIService.impressionRoute}/emotional/new'),
        headers: {"Content-Type": "application/json"},
        body: impression.toJson(),
      )).thenAnswer((_) async => http.Response("", 400));

      var result;
      try {
        result = await impressionsAPIService.route("/new",
            body: impression, client: client);
      } catch (e) {
        expect(e, isA<ImpressionsAPIException>());
        expect(e.message, "Error in Impression API Service with code 400");
        expect(result, isNull);
      }
    });
  });
  group('defaults', () {
    test('throws an [ImpressionAPIException] if the route is not correct',
        () async {
      try {
        await impressionsAPIService.route(
          '/errorRoute',
        );
      } catch (e) {
        expect(e, isA<ImpressionsAPIException>());
        expect(e.message, "Error in Impressions API Service");
      }
    });
  });
}
