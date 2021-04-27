import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/screens/impressions/emotional/emotionalImpression.dart';
import 'package:citylife/screens/impressions/emotional/local_widget/emotionalForm.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
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
  final impression = MockModel.getEmotional();
  final impressionsAPIService = MockImpressionsAPIService();
  final storageService = MockStorageService();
  final badgeAPIService = MockBadgeAPIService();

  final authService = MockAuthService();
  final authUser = MockModel.getUser();
  when(authService.authUser).thenReturn(authUser);
  group('Emotional Impression - ', () {
    Widget testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<CLImpression>.value(value: impression),
        ChangeNotifierProvider<AuthService>.value(value: authService),
        Provider<StorageService>.value(value: storageService),
        Provider<BadgeAPIService>.value(value: badgeAPIService),
        Provider<ImpressionsAPIService>.value(value: impressionsAPIService),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EmotionalImpression(),
        ),
      ),
    );

    testWidgets('all elements are correctly positioned -', (t) async {
      await t.pumpWidget(testApp);

      final formFinder = find.byType(EmotionalForm);
      expect(formFinder, findsOneWidget);

      final mapFinder = find.byType(LittleMap);
      expect(mapFinder, findsOneWidget);

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
