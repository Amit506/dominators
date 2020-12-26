import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dominators/StorageDataBase.dart/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // firebase instance

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('usersDetails').snapshots(),
              builder: (context, snapshot) {
                List<MembersContainer> memberWidgets = [];

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }

                final members = snapshot.data.docs;
                for (var member in members) {
                  final picUrl = member['profileUrl'];
                  print(picUrl);
                  final memberName = member['name'];
                  print(memberName);
                  final memberWidget = MembersContainer(
                    url: picUrl,
                    name: memberName,
                  );

                  memberWidgets.add(memberWidget);
                }
                return ListView(
                  shrinkWrap: true,
                  children: memberWidgets,
                );
              })),
    );
  }
}

class MembersContainer extends StatelessWidget {
  final url;
  final name;
  MembersContainer({this.name, this.url});
  @override
  Widget build(BuildContext context) {
    return Container(
     margin: EdgeInsets.symmetric(horizontal:5,vertical:3),
      child: Column(
        
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: url != null
                  ? NetworkImage(
                      url,
                    )
                  : AssetImage(
                      'assets/none_profile.jpg',
                    ),
            ),
            title: Text(name),
          ),
          Divider(),
        ],
      ),
    );
  }
}
