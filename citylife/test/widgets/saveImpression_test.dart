import 'dart:async';
import 'dart:io';

import 'package:citylife/utils/constants.dart';
import 'package:citylife/widgets/saveImpression.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/api_services_mock.dart';
import '../mocks/storage_service_mock.dart';
import '../utils/model_mocks.dart';

main() async {
  final impression = MockModel.getEmotional();
  final storageService = MockStorageService();
  final badgeAPIService = MockBadgeAPIService();
  final impressionAPIService = MockImpressionsAPIService();

  group('saveImpression Test: ', () {
    Widget testApp = MaterialApp(
        home: Scaffold(
      body: SaveImpression(
        isStructural: false,
        impression: impression,
        storageService: storageService,
        badgeAPIService: badgeAPIService,
        impressionsAPIService: impressionAPIService,
      ),
    ));

    testWidgets('save impression gives error', (t) async {
      when(impressionAPIService.route("/new", body: impression))
          .thenAnswer((_) async {
        return impression;
      });

      when(badgeAPIService.route("/impression/emotional",
              urlArgs: impression.userId))
          .thenAnswer((_) async => null);

      when(storageService.uploadImageList(
              false, impression.id, impression.images))
          .thenThrow(Exception("Images list was found null"));

      await t.pumpWidget(testApp);
      await t.pumpAndSettle();

      final iconFinder = find.byIcon(Icons.warning_amber_outlined);
      expect(iconFinder, findsOneWidget);
    });

    testWidgets('save impression correctly', (t) async {
      when(impressionAPIService.route("/new", body: impression))
          .thenAnswer((_) async => impression);

      when(badgeAPIService.route(
        "/impression/emotional",
        urlArgs: impression.userId,
      )).thenAnswer((_) async => null);

      List<Future<String>> images = [
        Future<String>.value('citylife\assets\images\avatar_1.jpg')
      ];

      when(storageService.uploadImageList(
              false, impression.id, impression.images))
          .thenAnswer((_) => images);
      await t.pumpWidget(testApp);
      await t.pump();

      final iconFinder = find.byIcon(Icons.done_all_outlined);
      expect(iconFinder, findsOneWidget);

      await t.pumpAndSettle(Duration(seconds: 1));

      expect(find.byType(SaveImpression), findsNothing);
    });
    testWidgets('save impression throws error', (t) async {
      when(impressionAPIService.route("/new", body: impression))
          .thenThrow(Exception("Test Exception"));

      await t.pumpWidget(testApp);
      await t.pump();

      final iconFinder = find.byIcon(Icons.warning_amber_outlined);
      expect(iconFinder, findsOneWidget);

      await t.pumpAndSettle(Duration(seconds: 1));
    });
  });
}
