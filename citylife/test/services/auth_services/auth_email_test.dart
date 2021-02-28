import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../utils/dbMock.dart';
import '../../utils/firebaseMock.dart';

main() {
  setupFirebaseAuthMocks();
  Firebase.initializeApp();

  group("Sign in with email and password -", () {
    final String email = "test@test.com";
    final String password = "testingPassword";
    final MockUserCredential credential = MockUserCredential(
      user: MockUser(
        uid: DBMock.userWithId.firebaseId,
      ),
    );
    group("no Exception - ", () {
      final MockFirebaseAuth _firebaseAuth = MockFirebaseAuth();
      final AuthService _authService = AuthService.instance(
        auth: _firebaseAuth,
        client: DBMock.userMockClient,
      );
      when(_firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((_) async => credential);
      when(_firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((_) async => credential);
      test("is newUser correct sign in", () async {
        credential.additionalUserInfo = AdditionalUserInfo(isNewUser: false);

        final CLUser user =
            await _authService.signInWithEmailAndPassword(email, password);
        expect(user, isNotNull);
        expect(user, isA<CLUser>());
      });

      test("is not newUser correct sign in", () async {
        credential.additionalUserInfo = AdditionalUserInfo(isNewUser: true);

        final CLUser user =
            await _authService.signInWithEmailAndPassword(email, password);
        expect(user, isNotNull);
        expect(user, isA<CLUser>());
      });
    });

    group("FirebaseAuthException thrown -", () {
      final String exceptionMessage = "Mock Auth Exception";
      final MockFirebaseAuth _firebaseAuth = MockFirebaseAuth();
      final AuthService _authService = AuthService.instance(
        auth: _firebaseAuth,
        client: DBMock.userMockClient,
      );

      test("email already in use", () async {
        when(_firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .thenThrow(FirebaseAuthException(
          message: exceptionMessage,
          code: "email-already-in-use",
        ));
        when(_firebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .thenAnswer((_) async => credential);
        await _authService.signInWithEmailAndPassword(email, password);
        throwsA(
            predicate((e) => e is AuthException && e.message.contains(email)));
      });

      test("wrong password", () async {
        when(_firebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .thenThrow(FirebaseAuthException(
          message: exceptionMessage,
          code: "wrong-password",
        ));
        expect(
            () async =>
                await _authService.signInWithEmailAndPassword(email, password),
            throwsA(predicate((e) => e is AuthException)));
      });

      test("other exception codes", () async {
        when(_firebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .thenThrow(FirebaseAuthException(
          message: exceptionMessage,
          code: "other-errors-in-citylife",
        ));
        expect(
            () async =>
                await _authService.signInWithEmailAndPassword(email, password),
            throwsA(predicate((e) => e is AuthException)));
      });
    });
  });
}
