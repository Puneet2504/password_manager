import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/pages/face_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/pages/login_page.dart';
import 'package:password_manager/provider/google_signin_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('profile Page'),
        backgroundColor: Colors.purple.shade700,
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => FacePage()));
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
            icon: const Icon(
              Icons.logout,
            ),
            iconSize: 20,
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('databases')
                  .doc(user!.uid)
                  .collection('password')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.length != 0) {
                    return Column(children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.photoURL!),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Name: ${user.displayName}',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.purple),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Email: ${user.email}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.purple),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Total Passwords: ${snapshot.data!.docs.length}',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.purple),
                      ),
                    ]);
                  }
                }
                return Column(children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Name: ${user.displayName}',
                    style: const TextStyle(fontSize: 24, color: Colors.purple),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Email: ${user.email}',
                    style: const TextStyle(fontSize: 20, color: Colors.purple),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Total Passwords: ${snapshot.data?.docs.length}',
                    style: const TextStyle(fontSize: 24, color: Colors.purple),
                  ),
                ]);
              }),
        ),
      ),
    );
  }
}
