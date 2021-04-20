import 'package:citylife/screens/login/2fa_login.dart';
import 'package:citylife/screens/login/2fa_login_state.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../mocks/2fa_login_state_mock.dart';
import '../../mocks/api_services_mock.dart';
import '../../utils/model_mocks.dart';

main() {
  final loginState = MockTwoFALoginState();
  final userAPIService = MockUserAPIService();
  final user = MockModel.getUser();

  final testApp = MultiProvider(
    providers: [
      ChangeNotifierProvider<TwoFALoginState>.value(value: loginState),
      Provider<UserAPIService>.value(value: userAPIService),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: TwoFactorsAuthentication(
          userId: user.id,
        ),
      ),
    ),
  );
  group('2 Factors Authentication -', () {
    group('all elements are correctly positioned -', () {
      testWidgets('pin input fields', (t) async {
        await t.pumpWidget(testApp);

        final svgFinder = find.byType(SvgPicture);
        expect(svgFinder, findsOneWidget);

        final pinCodesFinder = find.byType(PinCodeTextField);
        expect(pinCodesFinder, findsOneWidget);
      });
    });
  });
}
