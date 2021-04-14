import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../mocks/firebase_auth_mock.dart';
import '../mocks/shared_pref_service_mock.dart';
import '../mocks/user_api_service_mock.dart';
import '../utils/mock_firebase_credential.dart';
import '../utils/model_mocks.dart';
import 'auth_service_test.mocks.dart';

@GenerateMocks([
  http.Client,
])
void main() async {
  final genericErrorMessage = "Generic Error Message";
  final client = MockClient();

  final prefService = MockSharedPrefService();
  final userAPIService = MockUserAPIService();
  // final googleSignIn = MockGoogleSignIn();
  final firebaseAuth = MockFirebaseAuth();
  final authService = AuthService.instance(
    auth: firebaseAuth,
    client: client,
    userAPIService: userAPIService,
    sharedPrefService: prefService,
    // googleSignIn: googleSignIn,
  );
  group('email/password login', () {
    final mockUserCredential = MockUserCredential(
      additionalUserInfoField: AdditionalUserInfo(isNewUser: true),
    );
    final user = MockModel.getUser(
      firebaseId: mockUserCredential.user.uid,
    );

    when(prefService.setUserWith(spUserInfoKey, user))
        .thenAnswer((_) async => true);

    when(userAPIService.route(
      "/byFirebase",
      urlArgs: user.firebaseId,
      client: client,
    )).thenAnswer((_) async => user);

    test(
        'returns a [CLUser] if it is a new user and creates a new record on the database',
        () async {
      when(firebaseAuth.signInWithEmailAndPassword(
              email: user.email, password: user.password))
          .thenAnswer(
        (_) async => mockUserCredential,
      );

      when(
        userAPIService.route(
          "/new",
          body: CLUser(
            email: user.email,
            password: user.password,
            firebaseId: mockUserCredential.user.uid,
          ),
          client: client,
        ),
      ).thenAnswer((_) async => user);

      var result = await authService.signInWithEmailAndPassword(
        user.email,
        user.password,
        prefService: prefService,
      );

      expect(result, isA<CLUser>());
      verify(
        userAPIService.route(
          "/new",
          body: CLUser(
            email: user.email,
            password: user.password,
            firebaseId: mockUserCredential.user.uid,
          ),
          client: client,
        ),
      ).called(1);
      verify(
        firebaseAuth.signInWithEmailAndPassword(
          email: user.email,
          password: user.password,
        ),
      ).called(1);
    });
    test(
        'throws an [AuthException] with "wrong password" if Firebase throws an exception',
        () async {
      when(firebaseAuth.signInWithEmailAndPassword(
              email: user.email, password: user.password))
          .thenThrow(FirebaseAuthException(code: "wrong-password"));
      try {
        await authService.signInWithEmailAndPassword(user.email, user.password);
      } catch (e) {
        expect(e, isA<AuthException>());
        expect(e.message, "Wrong password");
      }
    });
    test(
        'throws an [AuthException] when creating a new user and sends an email verification',
        () async {
      when(firebaseAuth.signInWithEmailAndPassword(
              email: user.email, password: user.password))
          .thenThrow(FirebaseAuthException(code: "user-not-found"));
      when(firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: user.password))
          .thenAnswer((_) async => mockUserCredential);
      var result;
      try {
        result = await authService.signInWithEmailAndPassword(
          user.email,
          user.password,
          verifiedEmail: false,
        );
      } catch (e) {
        expect(e, isA<AuthException>());
        expect(e.message, "Sent verification email");
        expect(result, isNull);
      }
    });
    test('throws an [AuthException] if the email is already in use', () async {
      when(firebaseAuth.signInWithEmailAndPassword(
              email: user.email, password: user.password))
          .thenThrow(FirebaseAuthException(code: "user-not-found"));
      when(firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: user.password))
          .thenThrow(FirebaseAuthException(code: "email-already-in-use"));
      try {
        await authService.signInWithEmailAndPassword(
          user.email,
          user.password,
          verifiedEmail: false,
        );
      } catch (e) {
        expect(e, isA<AuthException>());
        expect(e.message, contains("Email already in use"));
      }
    });
    test(
        'throws an [AuthException] if anything the first attempt of signing in fails with any unknown code',
        () async {
      when(firebaseAuth.signInWithEmailAndPassword(
              email: user.email, password: user.password))
          .thenThrow(FirebaseAuthException(
              code: "different-code", message: genericErrorMessage));
      try {
        await authService.signInWithEmailAndPassword(
          user.email,
          user.password,
        );
      } catch (e) {
        expect(e, isA<AuthException>());
        expect(e.message, genericErrorMessage);
      }
    });
    test(
        'throws an [AuthException] if an exception different from [FirebaseAuthException] is thrown',
        () async {
      when(firebaseAuth.signInWithEmailAndPassword(
              email: user.email, password: user.password))
          .thenThrow(Exception(genericErrorMessage));
      expect(
          () async => await authService.signInWithEmailAndPassword(
              user.email, user.password),
          throwsA(isA<AuthException>()));
    });
  });
}
