
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dominators/StorageDataBase.dart/database.dart';
import 'package:dominators/TabBar1.dart/UploadingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DateTime now = DateTime.now();

class PostContainer extends StatefulWidget {
  @override
  _PostContainerState createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final textController = TextEditingController();
  String profilePic;
  String text;
  Future postText() async {
    var userid = _auth.currentUser.uid;
    var name = await StorageDataBase(uid: userid).userName();
    final time = now.toString();
    var profileic =
        await StorageDataBase(uid: _auth.currentUser.uid).profilePic();
    

    final timeStamp = FieldValue.serverTimestamp();
    if (postText != null) {
      await StorageDataBase(uid: userid)
          .uploadStatusText(text, name, time, profileic, timeStamp);
    } else {
      print('error');
    }
  }

  @override
  void initState() {
    super.initState();
    getprofilePic();
  }

  void getprofilePic() async {
    var temp = await StorageDataBase(uid: _auth.currentUser.uid).profilePic();
    setState(() {
      profilePic = temp.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
           Container(
        
        padding: EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
        height: 110,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: profilePic != null
                      ? NetworkImage(
                          profilePic,
                        )
                      : AssetImage(
                          'assets/none_profile.jpg',
                        ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextField(
                    
                    controller: textController,
                    onChanged: (value) {
                      setState(() {
                        text = value;
                      });
                    },
                    maxLines: 2,
                    decoration: InputDecoration.collapsed(
                      hintText: 'whats\'s in your mind',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    textController.clear();
                    await postText();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        content: const Text('uploaded sucesfully'),
                      ),
                    );
                  },
                  child: Text('post'),
                ),
              ],
            ),
            Divider(height: 5.0, thickness: 2.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              FlatButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UploadingPage()));
                },
                icon: Icon(
                  Icons.photo_library,
                  color: Colors.blue,
                ),
                label: Text('Photo'),
              ),
              VerticalDivider(width: 8.0),
              FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.video_call,
                  color: Colors.blue,
                ),
                label: Text('Room'),
              ),
            ]),
          ],
        ),
      
    );
  }
}
