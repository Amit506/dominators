import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

const dartChatTextStyle = TextStyle(
  fontFamily: 'Acme',
  fontSize: 45.0,
  fontWeight: FontWeight.w800,
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(
    color: Colors.black38,
  ),
  border: InputBorder.none,
  filled: false,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
