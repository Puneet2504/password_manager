import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final user = FirebaseAuth.instance.currentUser;
  void insertSubCollection(String service, String email, String password) {
    var db = FirebaseFirestore.instance.collection("databases");
    db
        .doc(user!.uid)
        .collection('password')
        .add({'Service': service, 'email': email, 'password': password});
  }
}
