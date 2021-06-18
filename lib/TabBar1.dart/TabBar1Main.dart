import 'package:cached_network_image/cached_network_image.dart';
import 'package:dominators/StorageDataBase.dart/database.dart';
import 'package:dominators/save_image.dart';
import 'package:flutter/material.dart';
import 'package:dominators/TabBar1.dart/PostContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

bool check = false;

DateTime now = DateTime.now();

class TabBar1 extends StatefulWidget {
  @override
  _TabBar1State createState() => _TabBar1State();
}

class _TabBar1State extends State<TabBar1> {
  final _firestore = FirebaseFirestore.instance;
  final StorageDataBase storageDataBase = StorageDataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              PostContainer(),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Posts')
                    .orderBy('timestamp')
                    .snapshots(),
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
                    final likes = post['likes'];

                    final notified = post['notified'];

                    if ((post.data() as Map).containsKey('postText')) {
                      if ((post.data() as Map).containsKey('url')) {
                        final postText = post['postText'];
                        final postUrl = post['url'];

                        final postWidget = ShowPostContainer(
                          src: postUrl,
                          text: postText,
                          docId: post.id,
                          dateTime: time,
                          likeCallBack: (val) async {
                            val++;

                            await storageDataBase.like(post.id, val);
                            setState(() {});
                          },
                          likes: likes,
                          name: senderName.toString(),
                          profileUrl: profilePic,
                        );
                        postWidgets.add(postWidget);
                        if (!notified) {
                          showPicNotification(senderName, "", postUrl,
                              postUrl.hashCode.toString());
                          storageDataBase.updateNotifyPost(post.id);
                        }
                      }
                    }
                    if ((post.data() as Map).containsKey('postedText')) {
                      final postText = post['postedText'];
                      final postWidget = ShowPostContainer(
                          src: 'null',
                          text: postText,
                          docId: post.id,
                          likes: likes,
                          dateTime: time,
                          likeCallBack: (val) async {
                            val++;
                            print('pressed' + val.toString());
                            await storageDataBase.like(post.id, val);
                            setState(() {});
                          },
                          name: senderName.toString(),
                          profileUrl: profilePic);
                      postWidgets.add(postWidget);
                    }
                    if ((post.data() as Map).containsKey('url') &&
                        !(post.data() as Map).containsKey('postText')) {
                      final postUrl = post['url'];
                      final postWidget = ShowPostContainer(
                          src: postUrl,
                          text: 'null',
                          docId: post.id,
                          dateTime: time,
                          likes: likes,
                          likeCallBack: (val) async {
                            val++;
                            print('pressed' + val.toString());
                            await storageDataBase.like(post.id, val);
                            setState(() {});
                          },
                          name: senderName.toString(),
                          profileUrl: profilePic);
                      postWidgets.add(postWidget);
                      if (!notified) {
                        showPicNotification(senderName, "", postUrl,
                            postUrl.hashCode.toString());
                        storageDataBase.updateNotifyPost(post.id);
                      }
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

  showPicNotification(
      String title, String body, String url, String fileName) async {
    final String bigPicturePath = await saveImage(url, fileName);

    final bigPictureStyle = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('dominator picture', 'dominatorPicture',
            'for dominator chat notification',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            styleInformation: bigPictureStyle,
            showWhen: false);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      2,
      title,
      "",
      platformChannelSpecifics,
    );
  }
}

class ShowPostContainer extends StatelessWidget {
  final src;
  final text;
  final name;
  final docId;
  final likes;
  final profileUrl;
  final dateTime;

  final Function(int) likeCallBack;

  ShowPostContainer(
      {this.src,
      this.text,
      this.likeCallBack,
      this.likes,
      this.name,
      this.profileUrl,
      this.dateTime,
      this.docId});
  @override
  Widget build(BuildContext context) {
    String timeElapsed;
    final minuteElapsed = now.difference(dateTime).inMinutes;
    final secondElapsed = now.difference(dateTime).inSeconds;
    final hourElapsed = now.difference(dateTime).inHours;
    final daysElapsed = now.difference(dateTime).inDays;

    if (daysElapsed > 0) {
      timeElapsed = daysElapsed.toString() + ' days ago';
    } else {
      if (hourElapsed > 0) {
        timeElapsed = hourElapsed.toString() + ' hours ago';
      } else {
        if (minuteElapsed > 0) {
          timeElapsed = minuteElapsed.toString() + ' minutes ago';
        } else {
          if (secondElapsed > 0) {
            timeElapsed = secondElapsed.toString() + ' seconds ago';
          } else {
            timeElapsed = 'just now';
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
                          : Flexible(
                              child: Text(
                              text,
                            ))
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
                child: CachedNetworkImage(
                  imageUrl: src.toString(),
                  fit: BoxFit.cover,
                ),
              )
            : SizedBox(height: 1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisSize: MainAxisSize.min,
                // textBaseline: TextBaseline.alphabetic,
                children: [
                  IconButton(
                      padding: EdgeInsets.all(2.0),
                      icon: Icon(Icons.thumb_up_alt),
                      onPressed: () {
                        likeCallBack(likes);
                      }),
                  Text(
                    'likes ' + likes.toString(),
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.comment), onPressed: () {}),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Text(timeElapsed,
              style: TextStyle(
                fontSize: 10,
              )),
        ),
      ]),
    );
  }
}
