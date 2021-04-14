import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

import '../utils/mock_firebase_credential.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  final currentUserField;

  MockFirebaseAuth({this.currentUserField});

  User get currentUser => currentUserField ?? MockUser();
}

class MockAuthCredential extends Mock implements AuthCredential {
  final String providerId;
  final String signInMethod;
  final String accessToken;
  final String idToken;

  MockAuthCredential({
    this.providerId,
    this.signInMethod,
    this.accessToken,
    this.idToken,
  });
}
