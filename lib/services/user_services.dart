//for all firebase related services for users
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  String collection = 'users';
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// to create new user set is used
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }

//to update user data update is used
  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).update(values);
  }

// get user data by id using get
  Future<DocumentSnapshot> getUserById(String id) async {
    var result = await _firestore.collection(collection).doc(id).get();
    return result;
  }
}
