import 'package:dominators/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'UserField.dart';
import 'package:dominators/Database.dart/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dominators/StorageDataBase.dart/database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GetUserInfo extends StatefulWidget {
  static String idd = 'UserInfo';

  @override
  _GetUserInfoState createState() => _GetUserInfoState();
}

class _GetUserInfoState extends State<GetUserInfo> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool spinner = false;
  var name;
  var gender;
  var dob;
  var profession;
  var relationshipStatus;

  File _image;

  Future uploadProfilPic() async {
    final picker = ImagePicker();
    PickedFile image;

    await Permission.photos.request();
    var permissionRequest = await Permission.photos.status;
    if (permissionRequest.isGranted) {
      image = await picker.getImage(source: ImageSource.gallery);
      
      File file = File(image.path);
       setState(() {
        _image = file;
      });

      

     
    } else {
      print('fbhjfvbdfjgbvjefkn');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
      
        body: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.32,
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              stops: [
                                0.1,
                                0.5,
                                0.7,
                                0.9
                              ],
                              colors: [
                                Colors.blue[800],
                                Colors.blue[700],
                                Colors.blue[500],
                                Colors.blue[400],
                              ])),
                    ),
                    Positioned(
                      top: 40,
                      left: MediaQuery.of(context).size.width * 0.25,
                      child: Material(
                        borderRadius: BorderRadius.circular(100),
                        elevation: 3,
                        
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _image != null
                                    ? FileImage(_image)
                                    : AssetImage('assets/none_profile.jpg'),
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 140,
                      left: 240,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await uploadProfilPic();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
                height: 3,
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: [
                        UserField(
                            text: 'Name',
                            onChanging: (String value) {
                              name = value;
                            },
                            icon: Icons.contacts_rounded),
                        SizedBox(height: 10),
                        UserField(
                          text: 'Gender',
                          onChanging: (String value) {
                            gender = value;
                          },
                          icon: Icons.group_outlined,
                        ),
                        SizedBox(height: 10),
                        UserField(
                            text: 'Date of Birth',
                            onChanging: (String value) {
                              dob = value;
                            },
                            icon: Icons.calendar_today),
                        SizedBox(height: 10),
                        UserField(
                            text: 'Relationship Status',
                            onChanging: (String value) {
                              relationshipStatus = value;
                            },
                            icon: Icons.family_restroom),
                        SizedBox(height: 10),
                        UserField(
                          text: 'Profession',
                          onChanging: (String value) {
                            profession = value;
                          },
                          icon: Icons.layers,
                        ),
                        SizedBox(height: 35),
                        RaisedButton(
                          textColor: Colors.white,
                          visualDensity:
                              VisualDensity(horizontal: 1.0, vertical: 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey[700])),
                          splashColor: Colors.grey[800],
                          onPressed: () async {
                            setState(() {
                              spinner = true;
                            });
                            var currentUserUid = _auth.currentUser.uid;
                            await DataBaseService(uid: currentUserUid)
                                .updateUserData(
                                    name == null ? 'unknown' : name,
                                    gender == null ? 'unknown' : gender,
                                    profession == null ? 'unknown' : profession,
                                    dob == null ? 'unknown' : dob,
                                    relationshipStatus == null
                                        ? 'unknown'
                                        : relationshipStatus);

                                        
                                          await StorageDataBase(uid: currentUserUid).uploadProfilepic(_image);
                                        
                            spinner = false;
                            Navigator.pushNamed(context, HomePage.id);
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(letterSpacing: 2),
                          ),
                          
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
