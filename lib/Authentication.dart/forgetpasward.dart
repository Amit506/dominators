import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasward extends StatefulWidget {
  @override
  _ForgetPaswardState createState() => _ForgetPaswardState();
}

class _ForgetPaswardState extends State<ForgetPasward> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/backgroundDominator.jpg'),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter your email'),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'email'),
              ),
            ),
            RaisedButton(
              onPressed: () {
                _auth.sendPasswordResetEmail(email: _email);
                Navigator.pop(context);
              },
              child: Text(' Send Request'),
            )
          ],
        ),
      ),
    );
  }
}
