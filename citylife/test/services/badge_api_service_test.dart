import 'dart:convert';

import 'package:citylife/models/cl_badges.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../utils/model_mocks.dart';
import 'badge_api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final errorMessage = "Generic error from the backend";
  final userId = 1;
  final client = MockClient();
  group('/by', () {
    test("returns a user's [CLBadge] if the http call completes successfully",
        () async {
      final badge = MockModel.getBadge();
      when(client.get(
        Uri.parse('$APIENDPOINT${BadgeAPIService.badgeRoute}/by/$userId'),
      )).thenAnswer((_) async => http.Response(jsonEncode(badge), 200));
      var result = await BadgeAPIService.route(
        '/by',
        urlArgs: userId,
        client: client,
      );

      expect(result, isA<CLBadge>());
    });
    test("throws a [BadgeAPIException] if the http call fails", () async {
      when(client.get(Uri.parse(
              '$APIENDPOINT${BadgeAPIService.badgeRoute}/by/$userId')))
          .thenAnswer((_) async => http.Response(errorMessage, 400));

      var result;
      try {
        await BadgeAPIService.route(
          '/by',
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<BadgeAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test("throws a [BadgeAPIException] if the http call fails (empty message)",
        () async {
      when(client.get(Uri.parse(
              '$APIENDPOINT${BadgeAPIService.badgeRoute}/by/$userId')))
          .thenAnswer((_) async => http.Response("", 400));

      var result;
      try {
        await BadgeAPIService.route(
          '/by',
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<BadgeAPIException>());
        expect(e.message, "Error while retrieving the badges of user $userId");
      }
    });
  });
  group('/login', () {
    test('returns a [Badge] if the http call completes successfully', () {
      <Badge, int>{
        Badge.Daily3: 3,
        Badge.Daily5: 5,
        Badge.Daily10: 10,
        Badge.Daily30: 30,
      }.forEach(
        (badge, daily) async {
          when(client.post(
            Uri.parse(
                '$APIENDPOINT${BadgeAPIService.badgeRoute}/login/$userId'),
          )).thenAnswer((_) async => http.Response("\"daily_$daily\"", 200));

          var result = await BadgeAPIService.route(
            "/login",
            urlArgs: userId,
            client: client,
          );
          expect(result, isA<Badge>());
          expect(result.index, badge.index);
        },
      );
    });
    test('throws a [BadgeAPIException] if the http call fails', () async {
      when(client.post(
        Uri.parse('$APIENDPOINT${BadgeAPIService.badgeRoute}/login/$userId'),
      )).thenAnswer((_) async => http.Response(errorMessage, 400));

      var result;
      try {
        result = await BadgeAPIService.route(
          "/login",
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<BadgeAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test('throws a [BadgeAPIException] if the http call fails (empty message)',
        () async {
      when(client.post(
        Uri.parse('$APIENDPOINT${BadgeAPIService.badgeRoute}/login/$userId'),
      )).thenAnswer((_) async => http.Response("", 400));

      var result;
      try {
        result = await BadgeAPIService.route(
          "/login",
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<BadgeAPIException>());
        expect(e.message, "Error in the postLoginBadge");
      }
    });
  });
  group('/impression', () {
    test('returns a [Badge] if the http call completes successfully', () {
      <Badge, int>{
        Badge.Structural1: 1,
        Badge.Structural5: 5,
        Badge.Structural10: 10,
        Badge.Structural25: 25,
        Badge.Structural50: 50,
      }.forEach((badge, number) async {
        when(client.post(Uri.parse(
                '$APIENDPOINT${BadgeAPIService.badgeRoute}/impression/structural/$userId')))
            .thenAnswer(
                (_) async => http.Response("\"structural_$number\"", 200));
        var result = await BadgeAPIService.route(
          "/impression/structural",
          urlArgs: userId,
          client: client,
        );
        expect(result, isA<Badge>());
        expect(result.index, badge.index);
      });

      <Badge, int>{
        Badge.Emotional1: 1,
        Badge.Emotional5: 5,
        Badge.Emotional10: 10,
        Badge.Emotional25: 25,
        Badge.Emotional50: 50,
      }.forEach((badge, number) async {
        when(client.post(Uri.parse(
                '$APIENDPOINT${BadgeAPIService.badgeRoute}/impression/emotional/$userId')))
            .thenAnswer(
                (_) async => http.Response("\"emotional_$number\"", 200));
        var result = await BadgeAPIService.route(
          "/impression/emotional",
          urlArgs: userId,
          client: client,
        );
        expect(result, isA<Badge>());
        expect(result.index, badge.index);
      });
    });
    test('throws a [BadgeAPIException] if the http call fails', () async {
      when(client.post(Uri.parse(
              '$APIENDPOINT${BadgeAPIService.badgeRoute}/impression/emotional/$userId')))
          .thenAnswer((_) async => http.Response(errorMessage, 400));
      var result;
      try {
        result = await BadgeAPIService.route(
          "/impression/emotional",
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<BadgeAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test('throws a [BadgeAPIException] if the http call fails (empty message)',
        () async {
      when(client.post(Uri.parse(
              '$APIENDPOINT${BadgeAPIService.badgeRoute}/impression/emotional/$userId')))
          .thenAnswer((_) async => http.Response("", 400));
      var result;
      try {
        result = await BadgeAPIService.route(
          "/impression/emotional",
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<BadgeAPIException>());
        expect(e.message, "Error in the postLoginBadge");
      }
    });
  });
  group('/techie', () {
    test('returns a [Badge] if the http call completes successfully', () async {
      when(client.post(Uri.parse(
              '$APIENDPOINT${BadgeAPIService.badgeRoute}/techie/$userId')))
          .thenAnswer((_) async => http.Response("", 200));
      var result = await BadgeAPIService.route(
        "/techie",
        urlArgs: userId,
        client: client,
      );

      expect(result, isA<Badge>());
      expect(result.index, Badge.Techie.index);
    });
    test('throws a [BadgeAPIException] if the http call fails', () async {
      when(client.post(Uri.parse(
              '$APIENDPOINT${BadgeAPIService.badgeRoute}/techie/$userId')))
          .thenAnswer((_) async => http.Response(errorMessage, 400));

      var result;
      try {
        result = await BadgeAPIService.route(
          "/techie",
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<BadgeAPIException>());
        expect(e.message, errorMessage);
      }
    });
    test('throws a [BadgeAPIException] if the http call fails (empty message)',
        () async {
      when(client.post(Uri.parse(
              '$APIENDPOINT${BadgeAPIService.badgeRoute}/techie/$userId')))
          .thenAnswer((_) async => http.Response("", 400));

      var result;
      try {
        result = await BadgeAPIService.route(
          "/techie",
          urlArgs: userId,
          client: client,
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<BadgeAPIException>());
        expect(e.message, "Error in the postTechieBadge");
      }
    });
  });
  group('defaults', () {
    test('throws a [BadgeAPIException] if the route is not correct', () async {
      var result;
      try {
        result = await BadgeAPIService.route(
          "/errorRoute",
        );
      } catch (e) {
        expect(result, isNull);
        expect(e, isA<BadgeAPIException>());
        expect(e.message, "Error in Badge API Service");
      }
    });
  });
}
