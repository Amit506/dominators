import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';


class StorageDataBase {

  final String uid;
  StorageDataBase({this.uid});

firebase_storage.Reference ref ;
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('Posts');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('usersDetails');
//creating storage reference named feedStore

/// to get username stored in userDetails
  Future userName()async {
    
    return  userCollection.doc(uid).get().then((value) =>(value.data()['name']));
    
  }


  final firebase_storage.Reference feedStorage =
      firebase_storage.FirebaseStorage.instance.ref().child('feedStore');
//to upload image to firebase
  Future uploadImage(File image ,String name,String time, String profilep,FieldValue timestamp) async {
    if (image != null) {
      ref= feedStorage.child(basename(image.path));
      
      await ref.putFile(image).whenComplete(() async{
    await ref.getDownloadURL().then((value) {
              postCollection.add({'url':value, 'name':name,'time':time,'profilePic':profilep,'timestamp':timestamp});    
    });
      });

    }
  }
   Future uploadImageWithpostText(File image ,String name,String postText,String time,String profilep,FieldValue timestamp) async {
    if (image != null) {
      ref= feedStorage.child(basename(image.path));
      
      await ref.putFile(image).whenComplete(() async{
    await ref.getDownloadURL().then((value) {
              postCollection.add({'url':value, 'name':name ,'postText':postText,'time':time,'profilePic':profilep,'timestamp':timestamp},);    
    });
      });

    }
  }
  Future uploadStatusText(String text,String name,String time,String profilep,FieldValue timestamp)async{

    if(text!=null){
      await postCollection.add({'postedText':text,'name':name,'time':time,'profilePic':profilep,'timestamp':timestamp});
    }
  }
  // to update profile pic
   Future uploadProfilepic(File image,) async {
    if (image != null) {
      ref= feedStorage.child(uid);
      
      await ref.putFile(image).whenComplete(() async{
    await ref.getDownloadURL().then((value) {
              userCollection.doc(uid).set({'profileUrl':value},SetOptions(merge : true))   ;
    });
      });

    }




  }
//to get profile details
 Future profileDetails()async {
    
    return  userCollection.doc(uid).get().then((value) =>(value.data()));
    
  }
   Future profileName()async {
    
    return  userCollection.doc(uid).get().then((value) =>(value.data()['name']));
    
  }


  Future profilePic()async{
    return userCollection.doc(uid).get().then((value) => (value.data()['profileUrl']));
  }








}
