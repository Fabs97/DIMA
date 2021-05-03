import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockUserCredential implements UserCredential {
  final additionalUserInfoField;
  final credentialField;
  final userField;

  MockUserCredential({
    this.additionalUserInfoField,
    this.credentialField,
    this.userField,
  });

  @override
  AdditionalUserInfo get additionalUserInfo =>
      additionalUserInfoField ?? AdditionalUserInfo(isNewUser: false);

  @override
  AuthCredential get credential =>
      credentialField ??
      AuthCredential(
        providerId: "Test Provider Id",
        signInMethod: "Test sign in method",
      );

  @override
  User get user => userField ?? MockUser();
}

class MockUser implements User {
  final displayNameField;
  final emailField;
  final emailVerifiedField;
  final isAnonymousField;
  final metadataField;
  final phoneNumberField;
  final photoURLField;
  final providerDataField;
  final refreshTokenField;
  final tenantIdField;
  final uidField;

  MockUser({
    this.displayNameField,
    this.emailField,
    this.emailVerifiedField,
    this.isAnonymousField,
    this.metadataField,
    this.phoneNumberField,
    this.photoURLField,
    this.providerDataField,
    this.refreshTokenField,
    this.tenantIdField,
    this.uidField,
  });

  @override
  Future<void> delete() {
    throw UnimplementedError();
  }

  @override
  String get displayName => displayNameField ?? "Test Display Name";

  @override
  String get email => emailField ?? "tester@tester.com";

  @override
  bool get emailVerified => emailVerifiedField ?? false;

  @override
  Future<String> getIdToken([bool forceRefresh = false]) {
    // TODO: implement getIdToken
    throw UnimplementedError();
  }

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) {
    // TODO: implement getIdTokenResult
    throw UnimplementedError();
  }

  @override
  bool get isAnonymous => isAnonymousField ?? false;

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) {
    // TODO: implement linkWithCredential
    throw UnimplementedError();
  }

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber,
      [RecaptchaVerifier verifier]) {
    // TODO: implement linkWithPhoneNumber
    throw UnimplementedError();
  }

  @override
  UserMetadata get metadata => metadataField ?? UserMetadata(1, 1);

  @override
  String get phoneNumber => phoneNumberField ?? "Test Phone Number";

  @override
  String get photoURL => photoURLField ?? "testphoto.url.test";

  @override
  List<UserInfo> get providerData => providerDataField ?? <UserInfo>[];

  @override
  Future<UserCredential> reauthenticateWithCredential(
      AuthCredential credential) {
    // TODO: implement reauthenticateWithCredential
    throw UnimplementedError();
  }

  @override
  String get refreshToken => refreshTokenField ?? "Test Refresh Token";

  @override
  Future<void> reload() {
    return null;
  }

  @override
  Future<void> sendEmailVerification([ActionCodeSettings actionCodeSettings]) {
    print("Sending email verification from mocked firebase credentials");
  }

  @override
  // TODO: implement tenantId
  String get tenantId => tenantIdField ?? "Test Tenant Id";

  @override
  // TODO: implement uid
  String get uid => uidField ?? "Test uid";

  @override
  Future<User> unlink(String providerId) {
    // TODO: implement unlink
    throw UnimplementedError();
  }

  @override
  Future<void> updateEmail(String newEmail) {
    // TODO: implement updateEmail
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(String newPassword) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) {
    // TODO: implement updatePhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile({String displayName, String photoURL}) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail,
      [ActionCodeSettings actionCodeSettings]) {
    // TODO: implement verifyBeforeUpdateEmail
    throw UnimplementedError();
  }
}

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
