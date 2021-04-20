import 'package:citylife/screens/my_impressions/local_widgets/impression_card.dart';
import 'package:citylife/screens/my_impressions/my_impressions_state.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:citylife/utils/emotional_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;

import '../../mocks/api_services_mock.dart';
import '../../mocks/io_http_client_mock.dart';
import '../../mocks/my_impressions_state_mock.dart';
import '../../mocks/storage_service_mock.dart';
import '../../utils/model_mocks.dart';

main() {
  setUp(() {
    io.HttpOverrides.global = new TestHttpOverrides();
  });
  group('Impression card -', () {
    final myImpressionsState = MockMyImpressionsState();
    final impressionsAPIService = MockImpressionsAPIService();
    final storageService = MockStorageService();
    final emotionalImpression = MockModel.getEmotional();
    final structuralImpression = MockModel.getStructural();
    final testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<MyImpressionsState>.value(
            value: myImpressionsState),
        Provider<ImpressionsAPIService>.value(value: impressionsAPIService),
        Provider<StorageService>.value(value: storageService),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ImpressionCard(impression: emotionalImpression),
        ),
      ),
    );
    group('all elements are correctly positioned -', () {
      group('emotional detail -', () {
        testWidgets('dismissible, card and icon', (t) async {
          await t.pumpWidget(testApp);

          final dismissibleFinder = find.byType(Dismissible);
          expect(dismissibleFinder, findsOneWidget);
          final cardFinder = find.byType(Card);
          expect(cardFinder, findsOneWidget);
          final iconFinder = find.byIcon(Icons.whatshot_outlined);
          expect(iconFinder, findsOneWidget);
          final rightIconFinder = find.byIcon(Icons.chevron_right);
          expect(rightIconFinder, findsOneWidget);
        });
        testWidgets('text', (t) async {
          await t.pumpWidget(testApp);

          final dateFinder = find.text(
              DateFormat.yMMMMd("en_US").format(emotionalImpression.timeStamp));
          expect(dateFinder, findsOneWidget);
          final placeTagFinder = find.text(emotionalImpression.placeTag);
          expect(placeTagFinder, findsOneWidget);
        });
      });
      group('structural detail -', () {
        final structuralApp = MultiProvider(
          providers: [
            ChangeNotifierProvider<MyImpressionsState>.value(
                value: myImpressionsState),
            Provider<ImpressionsAPIService>.value(value: impressionsAPIService),
            Provider<StorageService>.value(value: storageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ImpressionCard(impression: structuralImpression),
            ),
          ),
        );
        testWidgets('texts', (t) async {
          when(storageService.dowloadImpressionImages(structuralImpression))
              .thenAnswer(
                  (_) async => List.generate(10, (index) async => "$index"));
          await t.pumpWidget(structuralApp);

          final inkWellFinder = find.byType(InkWell);
          expect(inkWellFinder, findsOneWidget);

          await t.tap(inkWellFinder);
          await t.pumpAndSettle();

          final dialogFinder = find.byType(Dialog);
          expect(dialogFinder, findsOneWidget);

          final componentFinder = find.byIcon(Icons.domain_outlined);
          expect(componentFinder, findsOneWidget);
          final pathologyFinder = find.byIcon(Icons.help_outline_outlined);
          expect(pathologyFinder, findsOneWidget);
          final typologyFinder = find.byIcon(Icons.build_outlined);
          expect(typologyFinder, findsOneWidget);
        });
      });
    });
    group('interactions -', () {
      testWidgets('impression detail', (t) async {
        when(storageService.dowloadImpressionImages(emotionalImpression))
            .thenAnswer(
                (_) async => List.generate(10, (index) async => "$index"));
        await t.pumpWidget(testApp);

        final inkWellFinder = find.byType(InkWell);
        expect(inkWellFinder, findsOneWidget);

        await t.tap(inkWellFinder);
        await t.pumpAndSettle();

        final dialogFinder = find.byType(Dialog);
        expect(dialogFinder, findsOneWidget);

        final notesFinder = find.textContaining(emotionalImpression.notes);
        expect(notesFinder, findsOneWidget);

        final iconsFinder = find.byIcon(EUtils.getFrom(1));
        // ! Found double as we have more below the dialog
        expect(iconsFinder, findsNWidgets(10));
      });
    });
  });
}
