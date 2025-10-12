import 'package:cloud_firestore/cloud_firestore.dart';

class UserRemoteDataSource {
  Future addUser(String email, String uid ) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(uid).set({'email': email, 'uid': uid});
  }
}
