import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/screens/impressions/structural/local_widget/structuralForm.dart';
import 'package:citylife/screens/impressions/structural/structuralImpression.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:citylife/widgets/littleMap.dart';
import 'package:citylife/widgets/saveImpression.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:steps_indicator/steps_indicator.dart';

import '../../mocks/api_services_mock.dart';
import '../../mocks/auth_service_mock.dart';
import '../../mocks/storage_service_mock.dart';
import '../../utils/model_mocks.dart';

main() async {
  final impression = MockModel.getStructural();
  final impressionsAPIService = MockImpressionsAPIService();
  final storageService = MockStorageService();
  final badgeAPIService = MockBadgeAPIService();

  final authService = MockAuthService();
  final authUser = MockModel.getUser();
  when(authService.authUser).thenReturn(authUser);

  group('Structural Impression - ', () {
    Widget testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
        ChangeNotifierProvider<CLImpression>.value(value: impression),
        Provider<StorageService>.value(value: storageService),
        Provider<BadgeAPIService>.value(value: badgeAPIService),
        Provider<ImpressionsAPIService>.value(value: impressionsAPIService),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: StructuralImpression(),
        ),
      ),
    );

    testWidgets('all elements are correctly positioned -', (t) async {
      await t.pumpWidget(testApp);

      final scrollFinder = find.byType(SingleChildScrollView);
      expect(scrollFinder, findsWidgets);

      final mapFinder = find.byType(LittleMap);
      expect(mapFinder, findsOneWidget);

      final formFinder = find.byType(StructuralForm);
      expect(formFinder, findsOneWidget);

      final componentField = find.text('Component');
      expect(componentField, findsOneWidget);
      // expect(componentField.evaluate().first.widget, isA<EditableText>());
      final fieldFinder = find.ancestor(
          of: componentField, matching: find.byType(TextFormField));
      expect(fieldFinder, findsOneWidget);
      await t.enterText(fieldFinder, "Test");
      await t.pumpAndSettle();

      final pathologyField = find.text('Pathology');
      expect(pathologyField, findsOneWidget);
      final pathFieldFinder = find.ancestor(
          of: pathologyField, matching: find.byType(TextFormField));
      expect(pathFieldFinder, findsOneWidget);
      await t.enterText(pathFieldFinder, 'Test');
      await t.pumpAndSettle();

      final typeField = find.text('Type of Intervention');
      expect(typeField, findsOneWidget);
      final dropdownFinder = find.ancestor(
          of: typeField, matching: find.byType(DropdownButtonFormField));
      expect(dropdownFinder, findsOneWidget);
      final items = find.byType(DropdownMenuItem);
      expect(items, findsNWidgets(5));
      await t.tap(dropdownFinder);
      await t.pumpAndSettle();
      await t.tapAt(t.getCenter(items.first));
      await t.pumpAndSettle();

      final stepsFinder = find.byType(StepsIndicator);
      expect(stepsFinder, findsOneWidget);

      final buttonFinder = find.byType(MaterialButton);
      await t.tap(buttonFinder);
      await t.pumpAndSettle();

      await t.tap(buttonFinder);
      await t.pump();

      final saveFinder = find.byType(SaveImpression);
      expect(saveFinder, findsOneWidget);
    });
  });
}
