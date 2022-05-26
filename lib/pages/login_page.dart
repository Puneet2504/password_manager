import 'package:password_manager/provider/google_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 100),
          ImageAssets(),
          const SizedBox(height: 40),
          const SizedBox(height: 16),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Login To Your Account To Continue',
              style: TextStyle(fontSize: 16, color: Colors.purple),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.login();
            },
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Colors.purple,
            ),
            label: const Text(
              'Sign Up with Google',
              style: TextStyle(color: Colors.purple),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ]),
      ),
    );
  }
}

class ImageAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = const AssetImage('assets/login.png');
    Image image = Image(
      width: 500,
      height: 300,
      image: assetImage,
    );
    return Container(
      width: 500,
      height: 350,
      child: image,
    );
  }
}
