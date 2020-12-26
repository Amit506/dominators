import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String name;

  final time;
  MessageBubble(
      {this.sender,
      this.text,
      this.isMe,
      this.name,
      this.time});

  @override
  Widget build(BuildContext context) {
    final minute = DateTime.parse(time).minute.toString();
    final second = DateTime.parse(time).second.toString();
    final hour =DateTime.parse(time).hour.toString();
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black26,
            ),
          ),
        
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0))
                : BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.lightGreen,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.baseline,     // to get elements of row on the baseline 
                    textBaseline: TextBaseline.alphabetic, 
              
                
   children: [
     Text(text,style:TextStyle(fontSize: 16,),),
     SizedBox(width:11),
      Text('$minute:$second:$hour',style: TextStyle(fontSize: 6),),
      
   ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
