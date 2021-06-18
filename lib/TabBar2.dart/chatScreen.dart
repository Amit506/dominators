import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dominators/TabBar2.dart/MediaPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import '../main.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MessageBubble.dart';
import 'package:dominators/StorageDataBase.dart/database.dart';
import 'package:provider/provider.dart';
import 'WallpaperChanger.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
DateTime now = DateTime.now();
int order;

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
    }
  }

  Widget build(BuildContext context) {
    var wallpaperProvider = Provider.of<WallpaperChanger>(context);
    return Scaffold(
      body: Container(
        color: wallpaperProvider.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value; //Do something with the user input.
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.lightBlueAccent,
                      ),
                      onPressed: () async {
                        await availableCameras().then((value) {
                          print(value.toString());

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MediaPicker(
                                        cameras: value,
                                      )));
                        });
                      }),
                  IconButton(
                    onPressed: () async {
                      messageTextController.clear();
                      final name =
                          await StorageDataBase(uid: _auth.currentUser.uid)
                              .profileName();

                      _firestore.collection('messages').add({
                        'text': messageText,
                        'name': name,
                        'time': now.toString(),
                        "notified": false,
                        'sender': loggedInUser.email,
                        'timeStamp': FieldValue.serverTimestamp(),
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  List<Message> listmessage = [];

  final _listScrollController = ScrollController();
  final StorageDataBase _storageDataBase = StorageDataBase();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        // p.forEach((element) {
        //   print('-----------------------------------------------------------');

        //   if (element.doc.exists) {
        //     print(element.doc.data().toString());
        //     final bool notified = (element.doc.data() as Map)['notified'];
        //     if (!notified) {
        //       showNotification((element.doc.data() as Map)['name'],
        //           (element.doc.data() as Map)['text']);
        //     }
        //   }
        // });

        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messagetext = message['text'];
          final senderName = message['name'];
          final messagesender = message['sender'];
          final currentUser = loggedInUser.email;
          final time = message['time'];
          final notified = message['notified'];

          final messageBubble = MessageBubble(
            sender: messagesender,
            text: messagetext,
            name: senderName,
            time: time,
            isMe: currentUser == messagesender,
          );
          messagetext != null
              ? messageBubbles.add(messageBubble)
              : print('text');
          if (!notified) {
            showNotification(senderName, messagetext);
            _storageDataBase.updateNotifyMessage(message.id);
          }
        }
        Timer(
          Duration(seconds: 2),
          () => _listScrollController
              .jumpTo(_listScrollController.position.maxScrollExtent),
        );
        return Expanded(
          child: ListView(
            controller: _listScrollController,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }

  showNotification(
    String title,
    String body,
  ) async {
    listmessage.add(Message(body, DateTime.now(), Person(name: title)));
    final message = MessagingStyleInformation(
      Person(
        name: title,
      ),
      messages: listmessage,
      groupConversation: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'dominator', 'dominator', 'for dominator chat notification',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            styleInformation: message,
            showWhen: false);
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
