import 'package:flutter/material.dart';
import 'package:dominators/TabBar1.dart/PostContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


bool check = false;

DateTime now = DateTime.now();

class TabBar1 extends StatefulWidget {
  @override
  _TabBar1State createState() => _TabBar1State();
}

class _TabBar1State extends State<TabBar1> {
  final _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
          body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              PostContainer(),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Posts').orderBy('timestamp').snapshots(),
                builder: (context, snapshot) {
                  List<ShowPostContainer> postWidgets = [];

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }

                  final posts = snapshot.data.docs.reversed;
                  //   print(posts.toList()[1].data().containsKey('url'));

                  for (var post in posts) {
                    DateTime time = DateTime.parse(post['time'].toString());
                    
                    

                    final senderName = post['name'];
                    final profilePic = post['profilePic'];

                    if (post.data().containsKey('postText')) {
                      if (post.data().containsKey('url')) {
                        final postText = post['postText'];
                        final postUrl = post['url'];
                        final postWidget = ShowPostContainer(
                          src: postUrl,
                          text: postText,
                          dateTime: time,
                         
                          name: senderName.toString(),
                          profileUrl: profilePic,
                        );
                        postWidgets.add(postWidget);
                      }
                    }
                    if (post.data().containsKey('postedText')) {
                      final postText = post['postedText'];
                      final postWidget = ShowPostContainer(
                          src: 'null',
                          text: postText,
                          dateTime: time,
                          name: senderName.toString(),
                          profileUrl: profilePic);
                      postWidgets.add(postWidget);
                    }
                    if (post.data().containsKey('url') &&
                        !post.data().containsKey('postText')) {
                      final postUrl = post['url'];
                      final postWidget = ShowPostContainer(
                          src: postUrl,
                          text: 'null',
                           dateTime: time,
                          name: senderName.toString(),
                          profileUrl: profilePic);
                      postWidgets.add(postWidget);
                    }
                  }

                  return (ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: postWidgets,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowPostContainer extends StatelessWidget {
  final src;
  final text;
  final name;
  final profileUrl;
  final dateTime;

  ShowPostContainer({this.src, this.text, this.name, this.profileUrl,this.dateTime});
  @override
  Widget build(BuildContext context) {
    String timeElapsed ;
 final minuteElapsed = now.difference(dateTime).inMinutes;
                  final secondElapsed =now.difference(dateTime).inSeconds;
                  final hourElapsed = now.difference(dateTime).inHours;
                  final daysElapsed = now.difference(dateTime).inDays;

if(daysElapsed>0){

 timeElapsed=daysElapsed.toString()+' days ago';

}
else{
  if(hourElapsed>0){
    timeElapsed= hourElapsed.toString()+' hours ago';
  }
  else{
    if(minuteElapsed>0){
      timeElapsed=minuteElapsed.toString()+' minutes ago';
    }
    else{
      if(secondElapsed>0){
        timeElapsed= secondElapsed.toString()+' seconds ago';
      
      }
        else{
          timeElapsed ='just now';
        }
    }
  }
 
}



    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            child: Column(
              children: [
                Divider(
                  height: 4,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: profileUrl != null
                            ? NetworkImage(
                                profileUrl,
                              )
                            : AssetImage(
                                'assets/none_profile.jpg',
                              ),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      text == 'null'
                          ? SizedBox(
                              height: 10,
                            )
                          : Flexible(child: Text(text,))
                      
                      
                    ],
                  ),
                ),
                Divider(
                  height: 3,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ),
        src != 'null'
            ? Container(
                height: MediaQuery.of(context).size.height * 0.59,
                width: MediaQuery.of(context).size.width,
                child: Image.network(src.toString(), fit: BoxFit.cover),
              )
            : SizedBox(height: 1),

             
              Padding(
                padding: const EdgeInsets.symmetric(vertical:5,horizontal: 4),
                child: Text(timeElapsed,style: TextStyle(fontSize: 10,)
              ),
              ),
        SizedBox(height: 25)
      ]),
    );
  }
}
