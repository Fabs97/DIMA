import 'dart:math';

import 'package:citylife/screens/my_impressions/local_widgets/impression_card.dart';
import 'package:citylife/screens/my_impressions/my_impressions.dart';
import 'package:citylife/screens/my_impressions/my_impressions_state.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../mocks/api_services_mock.dart';
import '../../mocks/auth_service_mock.dart';
import '../../utils/model_mocks.dart';

main() {
  final authService = MockAuthService();
  final impressionsAPIService = MockImpressionsAPIService();
  final authUser = MockModel.getUser();
  when(authService.authUser).thenReturn(authUser);
  group('My Impressions -', () {
    var testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
        Provider<ImpressionsAPIService>.value(value: impressionsAPIService),
      ],
      child: MaterialApp(
        home: MyImpressions(),
      ),
    );

    group('all elements are correctly positioned -', () {
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
      testWidgets('listview', (t) async {
        var b = false;
        when(impressionsAPIService.route("/byUser", urlArgs: authUser.id))
            .thenAnswer((_) async {
          b = true;
          return impressions;
        });
        await t.pumpWidget(testApp);

        while (!b) {}
        await t.pumpAndSettle();

        final listViewFinder = find.byType(ListView);
        expect(listViewFinder, findsOneWidget);

        final cardsFinder = find.byType(ImpressionCard);
        expect(cardsFinder, findsWidgets);
      });
    });
  });
}
