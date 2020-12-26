import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dominators/StorageDataBase.dart/database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:image_picker/image_picker.dart';

DateTime now = DateTime.now();

class UploadingPage extends StatefulWidget {
  @override
  _UploadingPageState createState() => _UploadingPageState();
}

class _UploadingPageState extends State<UploadingPage> {
  StorageDataBase storageDataBase = StorageDataBase();
  FirebaseAuth _auth = FirebaseAuth.instance;
  File _image;
  
   final messageTextController = TextEditingController();
  String postText;
  bool progressIndicator = false;

  List<File> files = List<File>();

  Future getImage() async {
    final picker = ImagePicker();
    PickedFile image;

    await Permission.photos.request();
    var permissionRequest = await Permission.photos.status;
    if (permissionRequest.isGranted) {
      image = await picker.getImage(source: ImageSource.gallery);
     
      File file = File(image.path);

      setState(() {
        _image = file;
        files.add(File(image.path));
      });
    } else {
      print('permission not');
    }
  }

  Future postImageWithText() async {
    var userid = _auth.currentUser.uid;
    var name = await StorageDataBase(uid: userid).userName();
    final time = now.toString();
     
         final timeStamp =FieldValue.serverTimestamp();
    var profilePic =
        await StorageDataBase(uid: _auth.currentUser.uid).profilePic();

    if (postText == null) {
      for (var images in files) {
        await StorageDataBase(uid: userid)
            .uploadImage(images, name.toString(), time, profilePic,timeStamp);
      }
    }
    if (postText != null) {
      if (files.isEmpty) {
        print(postText.toString());
        await StorageDataBase(uid: userid)
            .uploadStatusText(postText, name, time, profilePic,timeStamp);
      } else {
        for (var images in files) {
          await StorageDataBase(uid: userid).uploadImageWithpostText(
              images, name.toString(), postText, time, profilePic,timeStamp);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dominator'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Container(
                child: TextField(
                  controller: messageTextController,
                  onChanged: (value) {
                    setState(() {
                      postText = value;
                    });
                  },
                  maxLines: 7,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      hintText: 'What\'s on your mind....',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                ),
              ),
              Divider(
                height: 40,
                thickness: 3,
              ),
              Flexible(
                  child: files.length.toString() == '0'
                      ? Container(
                          height: 70,
                          
                          child: Column(
                           
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right:10.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      size: 50,
                                    ),
                                    onPressed: () async {
                                      await getImage();
                                    }),
                              ),
                                  SizedBox(height:6),
                              Text('Add photo')
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemCount: files.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return progressIndicator
                                  ? CircularProgressIndicator()
                                  : Container(
                                      
                                      child: IconButton(
                                          
                                          icon: Icon(
                                            Icons.add,
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              progressIndicator = true;
                                            });
                                            await getImage();
                                            setState(() {
                                              progressIndicator = false;
                                            });
                                          }),
                                    );
                            } else {
                              print('done!!');
                              print(files[index - 1]);
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 2),
                                child: Image.file(
                                  files[index - 1],
                                  fit: BoxFit.fill,
                                ),
                              );
                            }
                          },
                        )),
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                  child: Text('Post'),
                  onPressed: () async {
                     messageTextController.clear();
                    await postImageWithText();
                    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: const Text('uploaded sucesfully'),
          ),
        );
        Navigator.pop(context);
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
