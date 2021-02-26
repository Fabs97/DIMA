import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

enum Status { Auth, Unauth }

class AuthStatus with ChangeNotifier {
  Status _status;

  Status get status {
    return _status;
  }

  void updateStatus(Status value) {
    _status = value;
    notifyListeners();
  }
}

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  AuthService._internal();
  factory AuthService() {
    return _singleton;
  }

  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  CLUser _authUser;

  CLUser get authUser => _authUser;

  /// Tries to sign in a new user, but if there's already a user with the provided
  /// email and password, then tries to login in with the given credentials.
  ///
  /// If no user is then found, throws an [AuthException] that provides the reason
  /// why the authentication has failed
  Future<CLUser> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential credential;
    try {
      credential = await _authInstance.createUserWithEmailAndPassword(
          email: email, password: password);
      _authUser = credential.additionalUserInfo.isNewUser
          ? await UserAPIService.route("/new",
              body: CLUser(
                email: email,
                password: password,
                firebaseId: credential.user.uid,
              ))
          : await _getUserInfoByFirebaseId(credential.user.uid);
      credential = await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);
      return _authUser;
    } on FirebaseAuthException catch (e, sTrace) {
      if (e.code.compareTo("email-already-in-use") == 0) {
        try {
          credential = await _authInstance.signInWithEmailAndPassword(
              email: email, password: password);
          return _getUserInfoByFirebaseId(credential.user.uid);
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case "email-already-in-use":
              print(
                  "[AuthService]::signInWithEmailAndPassword - Email $email already in use");
              throw new AuthException("Email $email already in use");
            case "wrong-password":
              print(
                  "[AuthService]::signInWithEmailAndPassword - Password $password is wrong");
              throw new AuthException("Wrong password");
            default:
              throw new AuthException(e.message);
          }
        } catch (e) {
          print(
              "[AuthService]::signInWithEmailAndPassword - ${e.message}\n$sTrace");
          throw new AuthException("${e.message}");
        }
      } else {
        print(
            "[AuthService]::signInWithEmailAndPassword - ${e.message}\n$sTrace");
        throw new AuthException("${e.message}");
      }
    } catch (e, sTrace) {
      throw new AuthException("Exception: ${e.message}\nStack Trace: $sTrace");
    }
  }

  Future<CLUser> _getUserInfoByFirebaseId(String firebaseId) async {
    return await UserAPIService.route(
      "/byFirebase",
      urlArgs: firebaseId,
    );
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
      return await _socialSignIn(googleCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithGoogle - $e\n$sTrace");
      return null;
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

      // Create a credential from the access token
      final AuthCredential githubAuthCredential =
          GithubAuthProvider.credential(result.token);

      // Once signed in, return the UserCredential
      return await _socialSignIn(githubAuthCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithGitHub - $e\n$sTrace");
      return null;
    }
  }

  Future<CLUser> signInWithFacebook() async {
    try {
      final AccessToken accessToken = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.token);

      // Once signed in, return the UserCredential
      return await _socialSignIn(facebookAuthCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithFacebook - $e\n$sTrace");
      return null;
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
      return await _socialSignIn(twitterAuthCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithTwitter - $e\n$sTrace");
      return null;
    }
  }

  Future<CLUser> _socialSignIn(AuthCredential authCredential) async {
    UserCredential credential =
        await _authInstance.signInWithCredential(authCredential);
    _authUser = credential.additionalUserInfo.isNewUser
        ? await UserAPIService.route("/new",
            body: CLUser(
              email: credential.user.email,
              name: credential.user.displayName,
              firebaseId: credential.user.uid,
            ))
        : await _getUserInfoByFirebaseId(credential.user.uid);
    return _authUser;
  }

  void signOut(BuildContext context) async {
    final AuthStatus authStatus = context.read<AuthStatus>();
    authStatus.updateStatus(Status.Unauth);
    await _authInstance.signOut();
  }
}
