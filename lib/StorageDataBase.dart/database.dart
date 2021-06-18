import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class StorageDataBase {
  final String uid;
  StorageDataBase({this.uid});

  firebase_storage.Reference ref;
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('Posts');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('usersDetails');
//creating storage reference named feedStore

  /// to get username stored in userDetails
  Future userName() async {
    return userCollection
        .doc(uid)
        .get()
        .then((value) => ((value.data() as Map)['name']));
  }

  final firebase_storage.Reference feedStorage =
      firebase_storage.FirebaseStorage.instance.ref().child('feedStore');
//to upload image to firebase
  Future uploadImage(File image, String name, String time, String profilep,
      FieldValue timestamp) async {
    if (image != null) {
      ref = feedStorage.child(basename(image.path));

      await ref.putFile(image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          postCollection.add({
            'url': value,
            'name': name,
            'time': time,
            'likes': 0,
            "notified": false,
            'profilePic': profilep,
            'timestamp': timestamp
          })
            ..then((value) {
              postCollection
                  .doc(value.id)
                  .update({"docId": value.id}).catchError((onError) {
                print(onError.toString());
              });
            });
        });
      });
    }
  }

  Future uploadImageWithpostText(File image, String name, String postText,
      String time, String profilep, FieldValue timestamp) async {
    if (image != null) {
      ref = feedStorage.child(basename(image.path));

      await ref.putFile(image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          postCollection.add(
            {
              'url': value,
              'name': name,
              'postText': postText,
              'time': time,
              "likes": 0,
              "notified": false,
              'profilePic': profilep,
              'timestamp': timestamp
            },
          )..then((value) {
              postCollection
                  .doc(value.id)
                  .update({"docId": value.id}).catchError((onError) {
                print(onError.toString());
              });
            });
        });
      });
    }
  }

  Future uploadStatusText(String text, String name, String time,
      String profilep, FieldValue timestamp) async {
    if (text != null) {
      await postCollection.add({
        'postedText': text,
        'name': name,
        'time': time,
        "likes": 0,
        "notified": false,
        'profilePic': profilep,
        'timestamp': timestamp
      }).then((value) {
        postCollection.doc(value.id).update({"docId": value.id})
          ..catchError((onError) {
            print(onError.toString());
          });
      });
    }
  }

  // to update profile pic
  Future uploadProfilepic(
    File image,
  ) async {
    if (image != null) {
      ref = feedStorage.child(uid);

      await ref.putFile(image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          userCollection
              .doc(uid)
              .set({'profileUrl': value}, SetOptions(merge: true))
                ..catchError((onError) {
                  print(onError.toString());
                });
        });
      });
    }
  }

//to get profile details
  Future profileDetails() async {
    return userCollection.doc(uid).get().then((value) => (value.data()))
      ..catchError((onError) {
        print(onError.toString());
      });
  }

  Future profileName() async {
    return userCollection
        .doc(uid)
        .get()
        .then((value) => ((value.data() as Map)['name']))
        .catchError((onError) {
      print(onError.toString());
    });
  }

  Future profilePic() async {
    return userCollection
        .doc(uid)
        .get()
        .then((value) => ((value.data() as Map)['profileUrl']));
  }

  updateDocId(String id) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(id)
        .update({"notified": true}).catchError((onError) {
      print(onError.toString());
    });
  }

  updateNotifyMessage(String id) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(id)
        .update({"notified": true}).catchError((onError) {
      print(onError.toString());
    });
  }

  updateNotifyPost(String id) async {
    await postCollection
        .doc(id)
        .update({"notified": true}).catchError((onError) {
      print(onError.toString());
    });
  }

  like(String docId, int val) async {
    // await postCollection.doc(docId).get().then((value) {
    //   int likes = (value.data() as Map)['likes'];
    print('updating' + val.toString());
    await postCollection.doc(docId).update({"likes": val});
    // });
  }
}
