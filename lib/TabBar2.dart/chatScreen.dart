import 'package:flutter/material.dart';
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
 int order ;
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
      final user =  _auth.currentUser;
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
    return 
      
       Scaffold(
        
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
               FlatButton(
       onPressed: () async{
        
         
         messageTextController.clear();
        final name =await StorageDataBase(uid:_auth.currentUser.uid).profileName();
                
       
         
         _firestore.collection('messages').add({
           'text': messageText,
           'name':name,
            'time': now.toString(),
           'sender': loggedInUser.email,
           'timeStamp':FieldValue.serverTimestamp(),
          
         });
       },
       child: Text(
         'Send',
         style: kSendButtonTextStyle,
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('timeStamp',descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messagetext = message['text'];
           final senderName = message['name'];
          final messagesender = message['sender'];
          final currentUser = loggedInUser.email;
          final time= message['time'];
        

          final messageBubble = MessageBubble(
            sender: messagesender,
            text: messagetext,
            name: senderName,
           time: time,
            isMe: currentUser == messagesender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
              
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
        );
      },
    );
  }
}