import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'User.dart';
import 'Signin.dart';
import 'package:dominators/HomePage.dart';


// page to check  authenticated user

class AuthChecker extends StatelessWidget {
   static String id = 'AuthCheckerScreen';
  @override
  Widget build(BuildContext context) {
     final user = Provider.of<Userr>(context);
      
   
      


    if (user == null) {
      return Signin();
    } else{
      return HomePage();
      }
  }
}