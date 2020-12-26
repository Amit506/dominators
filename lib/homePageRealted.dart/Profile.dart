import 'package:dominators/StorageDataBase.dart/database.dart';
import 'package:dominators/UserDetails.dart/GetUserInfo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Profile extends StatefulWidget {
  static String id = 'profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool progressCOntroller = false;

  var name;
  var profileUrl;
  var profession;
  var dob;
  var relationshipStatus;
  var gender;

  @override
  void initState() {

    super.initState();
    getProfile();
    
  }

  void getProfile() async {
   
    var currentUserUid = _auth.currentUser.uid;
    StorageDataBase storageDataBase = StorageDataBase(uid: currentUserUid);
    var profile = await storageDataBase.profileDetails();

    setState(() {
      name = profile['name'];
      print(name);
      profileUrl = profile['profileUrl'];
      profession = profile['profession'];
      gender = profile['gender'];
      dob = profile['dob'];
      relationshipStatus = profile['relationshipStatus'];
      print(profileUrl);
    });
    
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dominators'),
      ),
      body: progressCOntroller
          ? Center(child: CircularProgressIndicator())
          : Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //       begin: Alignment.topRight,
              //       end: Alignment.bottomLeft,
              //       stops: [
              //         0.1,
              //         0.5,
              //         0.7,
              //         0.9
              //       ],
              //       colors: [
              //         Colors.blue[700],
              //         Colors.blue[600],
              //         Colors.blue[500],
              //         Colors.blue[400],
              //       ]),
              // ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 15,
                          left: MediaQuery.of(context).size.width * 0.25,
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            elevation: 3,
                            
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: profileUrl != null
                                        ? NetworkImage(profileUrl.toString())
                                        : AssetImage('assets/none_profile.jpg'),
                                  )),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 240,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                              onPressed: () async {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListView(
                        children: [
                          CardWidget(
                            textToShow: name,
                            text : 'Name'
                          ),
                          CardWidget(
                            textToShow: relationshipStatus,
                            text: 'Relationshipstatus'
                          ),
                          CardWidget(
                            textToShow: gender,
                            text:'Gender'
                          ),
                          CardWidget(textToShow: dob,text:'Date of Birth'),
                          CardWidget(
                            textToShow: profession,
                            text:'Profession'
                          ),
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, GetUserInfo.idd);
                    },
                    child: Text('update profile'),
                  )
                ],
              ),
            ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final textToShow;
  final text;

  CardWidget({this.textToShow,this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      borderOnForeground: false,
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: ListTile(
        subtitle: Text(text),
        title: Text(
          textToShow != null ? textToShow : 'Unknown',
          style: TextStyle(
            fontSize: 15.0,
          letterSpacing: 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
