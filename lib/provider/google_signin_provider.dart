import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleSignInAccount;

  GoogleSignInAccount get googleSignInAccount => _googleSignInAccount!;
  // User login functions
  Future login() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;
    _googleSignInAccount = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
