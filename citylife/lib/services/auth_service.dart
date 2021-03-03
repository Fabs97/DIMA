import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/shared_pref_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  CLUser _authUser;

  CLUser get authUser {
    return _authUser;
  }

  void set authUser(CLUser user) {
    _authUser = user;
    notifyListeners();
  }

  AuthService.instance({this.auth, this.client}) {
    if (this.auth == null) this.auth = FirebaseAuth.instance;
    try {
      getUserInformation();
    } catch (e) {
      print(e);
    }
  }

  /// Tries to sign in a new user, but if there's already a user with the provided
  /// email and password, then tries to login in with the given credentials.
  ///
  /// If no user is then found, throws an [AuthException] that provides the reason
  /// why the authentication has failed
  Future<CLUser> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential credential;
    final SharedPrefService _prefService =
        await SharedPrefService.getInstance();
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
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
              break;
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
      if (credential.additionalUserInfo.isNewUser) {
        authUser = await UserAPIService.route("/new",
            body: CLUser(
              email: email,
              password: password,
              firebaseId: credential.user.uid,
            ),
            client: client);
        if (authUser != null) _prefService.setUserWith(spUserInfoKey, authUser);
      } else {
        authUser = await _getUserInfoByFirebaseId(credential.user.uid);
      }

      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    }
    return authUser;
  }

  Future<CLUser> checkUserInfoPersistence({SharedPrefService service}) async {
    if (service == null) service = await SharedPrefService.getInstance();
    authUser = service.getUserBy(spUserInfoKey);
    return authUser;
  }

  Future<CLUser> _getUserInfoByFirebaseId(String firebaseId) async {
    final prefService = await SharedPrefService.getInstance();
    final user = await UserAPIService.route(
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

      if (result.status == GitHubSignInResultStatus.ok) {
        // Create a credential from the access token
        final AuthCredential githubAuthCredential =
            GithubAuthProvider.credential(result.token);

        // Once signed in, return the UserCredential
        return await _socialSignIn(githubAuthCredential);
      } else {
        print(
            "[AuthService]::signInWithGithub - Status not ok: ${result.status}");
        return null;
      }
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
    UserCredential credential = await auth.signInWithCredential(authCredential);
    authUser = credential.additionalUserInfo.isNewUser
        ? await UserAPIService.route("/new",
            body: CLUser(
              email: credential.user.email,
              name: credential.user.displayName,
              firebaseId: credential.user.uid,
            ),
            client: client)
        : await _getUserInfoByFirebaseId(credential.user.uid);
    return authUser;
  }

  void signOut(BuildContext context) async {
    final SharedPrefService _prefService =
        await SharedPrefService.getInstance();
    if (await _prefService.deleteByKey(spUserInfoKey)) {
      await auth.signOut();
    } else {
      throw new AuthException("Error while signing out, please try again");
    }
  }

  void getUserInformation() {
    _getUserInfoByFirebaseId(auth.currentUser.uid).then((userInfo) {
      if (userInfo != null) {
        authUser = userInfo;
      }
    });
  }
}
