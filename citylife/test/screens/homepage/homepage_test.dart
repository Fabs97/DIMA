import 'package:citylife/screens/homepage/homepage.dart';
import 'package:citylife/screens/map_impressions/local_widgets/my_markers_state.dart';
import 'package:citylife/screens/my_impressions/my_impressions.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../mocks/api_services_mock.dart';
import '../../mocks/auth_service_mock.dart';
import '../../mocks/badge_dialog_state_mock.dart';
import '../../mocks/my_markers_state_mock.dart';
import '../../utils/model_mocks.dart';

main() async {
  final impression = MockModel.getStructural();
  final markers = MockMyMarkersState();
  final badgeAPIService = MockBadgeAPIService();
  final badgeDialogState = MockBadgeDialogState();
  final impressionsAPIService = MockImpressionsAPIService();

  final authService = MockAuthService();
  final authUser = MockModel.getUser();
  when(authService.authUser).thenReturn(authUser);
  group('Homepage -', () {
    Widget testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
        ChangeNotifierProvider<MyMarkersState>.value(value: markers),
        Provider<BadgeAPIService>.value(value: badgeAPIService),
        Provider<BadgeDialogState>.value(value: badgeDialogState),
        Provider<ImpressionsAPIService>.value(value: impressionsAPIService),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: HomePage(userId: authUser.id, badgeAPIService: badgeAPIService),
        ),
      ),
    );

    testWidgets('test homepage structure', (t) async {
      when(badgeAPIService.route("/login", body: impression.userId))
          .thenAnswer((_) async {
        return null;
      });

      await t.pumpWidget(testApp);

      final barFinder = find.byType(BottomNavigationBar);
      expect(barFinder, findsOneWidget);

      final itemFinder = find.byType(Icon);
      expect(itemFinder, findsNWidgets(5));

      final listFinder = find.byIcon(Icons.list_sharp);
      await t.tap(listFinder);
      await t.pump();

      final myImpressions = find.byType(MyImpressions);
      expect(myImpressions, findsOneWidget);
    });
  });
}
