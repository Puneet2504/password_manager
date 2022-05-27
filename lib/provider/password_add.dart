import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class for the Firestore Database
class FirebaseService {
  final user = FirebaseAuth.instance.currentUser;

  void insertSubCollection(
      String service, String email, String password, String key, String iv) {
    var db = FirebaseFirestore.instance.collection("databases");
    db.doc(user!.uid).collection('password').add({
      'Service': service,
      'email': email,
      'password': password,
      'key': key,
      'IV': iv
    });
  }
}
