import 'package:password_manager/pages/face_page.dart';
import 'package:password_manager/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/provider/google_signin_provider.dart';
import 'package:provider/provider.dart';

class Checker extends StatelessWidget {
  const Checker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);
            if (provider.isSigningIn) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return FacePage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
