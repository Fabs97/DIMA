import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/shared_pref_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' show Client;
import 'package:citylife/utils/constants.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class AuthService with ChangeNotifier {
  FirebaseAuth auth;
  final Client client;
  final UserAPIService userAPIService;
  final SharedPrefService sharedPrefService;

  CLUser _authUser;

  bool get isAuthenticated => this._authUser != null;

  CLUser get authUser {
    return _authUser;
  }

  set authUser(CLUser user) {
    _authUser = user;
    notifyListeners();
  }

  void reloadUser() {
    _getUserInfoByFirebaseId(_authUser.firebaseId);
  }

  AuthService.instance({
    this.auth,
    this.client,
    @required this.userAPIService,
    this.sharedPrefService,
  }) {
    if (this.auth == null) this.auth = FirebaseAuth.instance;
    try {
      getUserInformation(sharedPrefService);
    } catch (e) {
      print(e);
    }
  }

  /// Tries to sign in a new user, but if there's already a user with the provided
  /// email and password, then tries to login in with the given credentials.
  ///
  /// If no user is then found, throws an [AuthException] that provides the reason
  /// why the authentication has failed
  Future<CLUser> signInWithEmailAndPassword(String email, String password,
      {bool verifiedEmail = false, SharedPrefService prefService}) async {
    UserCredential credential;
    final SharedPrefService _prefService =
        prefService ?? await SharedPrefService.getInstance();
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      verifiedEmail = true;
    } on FirebaseAuthException catch (e, sTrace) {
      switch (e.code) {
        case "wrong-password":
          print(
              "[AuthService]::signInWithEmailAndPassword - Password $password is wrong");
          throw new AuthException("Wrong password");
        case "user-not-found":
          {
            try {
              credential = await auth.createUserWithEmailAndPassword(
                  email: email, password: password);
              credential.user.sendEmailVerification();
              throw new AuthException("Sent verification email");
            } on FirebaseException catch (e) {
              if (e.code.contains("email-already-in-use")) {
                print(
                    "[AuthService]::signInWithEmailAndPassword - Email $email already in use");
                throw new AuthException(
                    "Email already in use. Maybe try with a different sign in option?");
              }
            }
            break;
          }
        default:
          throw new AuthException(e.message ?? "Error in AuthService");
      }
    } catch (e, sTrace) {
      throw new AuthException("Exception: ${e.message}\nStack Trace: $sTrace");
    } finally {
      if (credential?.additionalUserInfo?.isNewUser ?? false) {
        authUser = await userAPIService.route(
          "/new",
          body: CLUser(
            email: email,
            password: password,
            firebaseId: credential.user.uid,
          ),
          client: client,
        );
      } else if (verifiedEmail) {
        // ! Can't be tested due to double auth.signInWithEmailAndPassword calls
        // ! One would need to throw an error and one answer, but this is not possible
        credential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        authUser = await _getUserInfoByFirebaseId(credential.user.uid);
        if (authUser != null) _prefService.setUserWith(spUserInfoKey, authUser);
      }
    }
    return authUser;
  }

  Future<CLUser> checkUserInfoPersistence({SharedPrefService service}) async {
    service = service ?? await SharedPrefService.getInstance();
    authUser = service.getUserBy(spUserInfoKey);
    return authUser;
  }

  Future<CLUser> _getUserInfoByFirebaseId(String firebaseId,
      {SharedPrefService prefService}) async {
    prefService = prefService ?? await SharedPrefService.getInstance();
    final user = await userAPIService.route(
      "/byFirebase",
      urlArgs: firebaseId,
      client: client,
    );
    prefService.setUserWith(spUserInfoKey, user);
    return user;
  }

  Future<CLUser> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential googleCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await socialSignIn(googleCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithGoogle - $e\n$sTrace");
      throw new AuthException(
          e.message ?? "Could not sign in with Google, please try again");
    }
  }

  Future<CLUser> signInWithGitHub(BuildContext context) async {
    try {
      const clientId = String.fromEnvironment("CITYLIFE_GITHUB_CLIENT_ID");
      const clientSecret =
          String.fromEnvironment("CITYLIFE_GITHUB_CLIENT_SECRET");
      const redirectUrl = String.fromEnvironment("CITYLIFE_AUTH_REDIRECT_URL");

      if (clientId == null || clientSecret == null || redirectUrl == null)
        throw Exception(
            "Environment variables not found!\nclientId = $clientId\nclientSecret = $clientSecret\nredirectUrl = $redirectUrl");

      final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUrl: redirectUrl,
      );

      // Trigger the sign-in flow
      final result = await gitHubSignIn.signIn(context);

      if (result.status == GitHubSignInResultStatus.ok) {
        // Create a credential from the access token
        final AuthCredential githubAuthCredential =
            GithubAuthProvider.credential(result.token);

        // Once signed in, return the UserCredential
        return await socialSignIn(githubAuthCredential);
      } else {
        print(
            "[AuthService]::signInWithGithub - Status not ok: ${result.status}");
        throw new AuthException(
            "Could not sign in with Github, status: ${result.status}");
      }
    } catch (e, sTrace) {
      print("[AuthService]::signInWithGitHub - $e\n$sTrace");
      throw new AuthException(
          e.message ?? "Could not sign in with Github, please try again");
    }
  }

  Future<CLUser> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.accessToken == null)
        throw new AuthException("Access token is null");
      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken.token);

      // Once signed in, return the UserCredential
      return await socialSignIn(facebookAuthCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithFacebook - $e\n$sTrace");
      throw new AuthException(
          e.message ?? "Could not sign in with Facebook, please try again");
    }
    // Trigger the sign-in flow
  }

  Future<CLUser> signInWithTwitter() async {
    try {
      const consumerKey =
          String.fromEnvironment("CITYLIFE_TWITTER_CONSUMER_KEY");
      const consumerSecret =
          String.fromEnvironment("CITYLIFE_TWITTER_CONSUMER_SECRET");
      // Create a TwitterLogin instance
      final TwitterLogin twitterLogin = new TwitterLogin(
        consumerKey: consumerKey,
        consumerSecret: consumerSecret,
      );

      // Trigger the sign-in flow
      final TwitterLoginResult loginResult = await twitterLogin.authorize();

      // Get the Logged In session
      final TwitterSession twitterSession = loginResult.session;

      // Create a credential from the access token
      final AuthCredential twitterAuthCredential =
          TwitterAuthProvider.credential(
        accessToken: twitterSession.token,
        secret: twitterSession.secret,
      );

      // Once signed in, return the UserCredential
      return await socialSignIn(twitterAuthCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithTwitter - $e\n$sTrace");
      throw new AuthException(
          e.message ?? "Could not sign in with Twitter, please try again");
    }
  }

  Future<CLUser> socialSignIn(AuthCredential authCredential) async {
    try {
      UserCredential credential =
          await auth.signInWithCredential(authCredential);
      authUser = credential.additionalUserInfo.isNewUser
          ? await userAPIService.route("/new",
              body: CLUser(
                email: credential.user.email,
                name: credential.user.displayName,
                firebaseId: credential.user.uid,
              ),
              client: client)
          : await _getUserInfoByFirebaseId(credential.user.uid);
      return authUser;
    } catch (e) {
      rethrow;
    }
  }

  void signOut(BuildContext context) async {
    final SharedPrefService _prefService =
        await SharedPrefService.getInstance();
    if (await _prefService.deleteByKey(spUserInfoKey)) {
      authUser = null;
      await auth.signOut();
    } else {
      throw new AuthException("Error while signing out, please try again");
    }
  }

  void getUserInformation(SharedPrefService sharedPrefService) {
    if (auth.currentUser != null) {
      _getUserInfoByFirebaseId(auth.currentUser.uid,
              prefService: sharedPrefService)
          .then((userInfo) {
        if (userInfo != null) {
          authUser = userInfo;
        }
      });
    }
  }
}
