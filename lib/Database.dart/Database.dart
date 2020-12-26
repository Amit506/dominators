import 'package:cloud_firestore/cloud_firestore.dart';


class DataBaseService {
  final String uid;
  DataBaseService({this.uid});
 
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('usersDetails');

  Future updateUserData(String name, String gender, String profession,
      String dob, String status) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'gender': gender,
      'profession': profession,
      'dob': dob,
      'relationshipStatus': status,
      
    });
  }

  Stream<QuerySnapshot> get userDetails {
    return userCollection.snapshots();
  }
 
  
}
