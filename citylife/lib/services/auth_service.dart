import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  AuthService._internal();
  factory AuthService() {
    return _singleton;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithGoogle - $e\n$sTrace");
      return null;
    }
  }

  Future<UserCredential> signInWithGitHub(BuildContext context) async {
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
      return await FirebaseAuth.instance
          .signInWithCredential(githubAuthCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithGitHub - $e\n$sTrace");
      return null;
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      final AccessToken accessToken = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.token);

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithFacebook - $e\n$sTrace");
      return null;
    }
    // Trigger the sign-in flow
  }

  Future<UserCredential> signInWithTwitter() async {
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
      return await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential);
    } catch (e, sTrace) {
      print("[AuthService]::signInWithTwitter - $e\n$sTrace");
      return null;
    }
  }
}
