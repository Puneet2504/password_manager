import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:clipboard/clipboard.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  // Future function to delete data from database
  Future<void> deleteData(id) {
    return FirebaseFirestore.instance
        .collection('databases')
        .doc(user!.uid)
        .collection('password')
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Falied to delete user"));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home page'),
          backgroundColor: Colors.purple.shade700,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 14),
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
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.purple.shade400,
                        ),
                        child: ListTile(
                          onTap: (() async {
                            await FlutterClipboard.copy(decrypt(
                                Encrypted.fromBase16(
                                    documentSnapshot['password']),
                                Key.fromBase16(documentSnapshot['key']),
                                IV.fromBase16(documentSnapshot['IV'])));
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBars('Copied To Clipboard!'));
                          }),
                          title: Text(
                            documentSnapshot['Service'],
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          subtitle: Text(
                            documentSnapshot['email'],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBars('Data Deleted Successfully!'));
                              deleteData(documentSnapshot.id);
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 140),
                    child: Column(children: [
                      ImageAssets(),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Oops! No Data',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.purple,
                        ),
                      ),
                    ]),
                  ));
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      );
  SnackBar snackBars(String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.purple.shade400,
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 1),
      shape: const StadiumBorder(),
      behavior: SnackBarBehavior.floating,
    );
    return snackBar;
  }

  //String Function to decrypt the password
  String decrypt(Encrypted password, Key key, IV iv) {
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt(password, iv: iv);
    return decrypted;
  }
}

class ImageAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = const AssetImage('assets/empty.png');
    Image image = Image(
      width: 500,
      height: 200,
      image: assetImage,
    );
    return Container(
      width: 500,
      height: 250,
      child: image,
    );
  }
}
