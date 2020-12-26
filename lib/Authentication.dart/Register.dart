import 'package:dominators/UserDetails.dart/GetUserInfo.dart';
import 'package:flutter/material.dart';
import 'package:dominators/Authentication.dart/AuthService.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Register extends StatefulWidget {
  static String id = 'RegisterScreen';

  @override
  _RegisterState createState() => _RegisterState();
}

final AuthService _auth = AuthService();
final _formKey = GlobalKey<FormState>();

bool spinner = false;
String email = '';
String passward = '';
String error = '';

class _RegisterState extends State<Register>with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
         resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/backgroundDominator.jpg'),fit: BoxFit.fill)
          ),
          child: Form(
            key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                         
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Hero(
                tag: 'dominators',
                                child: Text(
                  'Dominators',
                  style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Bungee',
                   fontWeight: FontWeight.w300,
                    foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.white, Colors.grey],
                        ).createShader(Rect.fromLTRB(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ),
              SizedBox(height:30),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  hintText: 'Enter your email',
                  contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400], width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  filled: true,
                   fillColor: Colors.blue[100],
                  hintStyle: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                onChanged: (value) {
                  passward = value;
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Passward',
                  labelStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  hintText: 'Enter your passward',
                  contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400], width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  filled: true,
                   fillColor: Colors.blue[100],
                  hintStyle: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ),
              SizedBox(
   height: 20,
              ),
              Material(
                elevation: 5.0,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(25.0),
                child: MaterialButton(
                  onPressed: () async {
                    setState(() {
                        spinner = true;
                    });
                    if (_formKey.currentState.validate()) {
                        dynamic result = await _auth.registerWithEmailPassword(
                            email, passward);
                             if (result == null) {
                          setState(() {
                            error = 'enter valid email id';
                            spinner = false;
                          });
                        }
                        else{
                            Navigator.pushNamed(context, GetUserInfo.idd);
                        }
                     
                    }
                    setState(() {
                        spinner = false;
                    });
                  },
                  minWidth: 200.0,
                  height: 40.0,
                  child: Text('Register',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400,letterSpacing: 1,)),
                ),
              ),
              SizedBox(height:5),
              Text(error),
            ]),
                      ),
          ),
        ),
      ),
    );
  }
}
