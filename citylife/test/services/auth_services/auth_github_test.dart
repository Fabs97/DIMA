import 'dart:io';

import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';

import '../../utils/dbMock.dart';
import '../../utils/firebaseMock.dart';
import '../../utils/mocks.dart';

main() {
  // setupFirebaseAuthMocks();
  // Firebase.initializeApp();

  // group("Sign in with Github -", () {
  //   test("no env variables returns null", () async {
  //     final _authInstance = AuthService.instance();
  //     final userShouldBeNull = await _authInstance.signInWithGitHub(null);

  //     expect(userShouldBeNull, isNull);
  //   });

  //   test("correct sign in", () async {
  //     final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  //     final MockClient dbClient = DBMock.userMockClient;
  //     final AuthService _authInstance = AuthService.instance(
  //       auth: mockFirebaseAuth,
  //       client: dbClient,
  //     );
  //     final MockGithubSignIn mockGithubSignIn = MockGithubSignIn();
  //     final MockBuildContext buildContext = MockBuildContext();
  //     final OAuthCredential credential = OAuthCredential(
  //       providerId: "testProviderId",
  //       signInMethod: "testSignInMethod",
  //     );
  //     when(mockGithubSignIn.signIn(buildContext)).thenAnswer(
  //       (_) async => GitHubSignInResult(
  //         GitHubSignInResultStatus.ok,
  //         token: "TestToken",
  //       ),
  //     );

  //     // when(MockGithubAuthProvider.credential("t"))
  //     //     .thenAnswer((_) => (String t) => credential);

  //     when(mockFirebaseAuth.signInWithCredential(credential))
  //         .thenAnswer((_) async => MockUserCredential(
  //               additionalUserInfo: AdditionalUserInfo(isNewUser: true),
  //             ));

  //     // Platform.environment.addEntries([
  //     //   MapEntry("CITYLIFE_GITHUB_CLIENT_ID", "TestClientId"),
  //     //   MapEntry("CITYLIFE_GITHUB_CLIENT_SECRET", "TestClientSecret"),
  //     //   MapEntry("CITYLIFE_AUTH_REDIRECT_URL", "TestRedirectUrl"),
  //     // ]);

  //     final u = _authInstance.signInWithGitHub(buildContext);

  //     expect(u, isNotNull);
  //   });
  // });
}
