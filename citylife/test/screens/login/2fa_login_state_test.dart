import 'package:citylife/screens/login/2fa_login_state.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('2FA Login State -', () {
    final TwoFALoginState state = TwoFALoginState();
    test('authenticated initialized to false', () {
      expect(state.authenticated, false);
    });
    test('authenticated must have a public setter', () {
      expect(state.authenticated, false);
      state.authenticated = true;
      expect(state.authenticated, true);
    });
  });
}
