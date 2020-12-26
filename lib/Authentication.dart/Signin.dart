import 'package:dominators/Authentication.dart/AuthService.dart';
import 'package:dominators/Authentication.dart/Register.dart';
import 'package:dominators/Authentication.dart/forgetpasward.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Signin extends StatefulWidget {
  static String id = 'SignInScreen';
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> with SingleTickerProviderStateMixin {
 


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool spinner = false;
  

  String email = '';
  String passward = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/backgroundDominator.jpg'),
                  fit: BoxFit.fill)),
          child: Form(
            key: _formKey,
            child:
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Hero(
                  tag: 'dominators',
                                child: Text(
                    'Dominators',
                    style: TextStyle(
                      fontSize:  40,
                      fontFamily: 'Bungee',
                      fontWeight: FontWeight.w400,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.white, Colors.grey],
                        ).createShader(Rect.fromLTRB(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
              ),
              SizedBox(height:30),
              TextFormField(
                  validator: (val) => val.isEmpty ? 'enter email' : null,
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
              TextFormField(
                  validator: (val) =>
                      val.length < 6 ? 'more than 6 character is required' : null,
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
                  height: 20.0,
              ),
              Material(
                  elevation: 5.0,
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(25.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          spinner = true;
                        });

                        dynamic result =
                            await _auth.signInWithEmailPassword(email, passward);
                        if (result == null) {
                          setState(() {
                            error =
                                'error in signin try again or else create account';
                            spinner = false;
                          });
                        }
                      }
                    },
                    minWidth: 200.0,
                    height: 40.0,
                    child: Text('Log in',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400,letterSpacing: 1,),)
                  ),
              ),
              SizedBox(height: 5),
              Text(
                  error,
                  style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                  height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                       focusNode: FocusNode(),
                       
                          onPressed: () {
                           
                            Navigator.pushNamed(context, Register.id);
                          },
                          child: Text('Register now',style: TextStyle(color: Colors.white,fontSize: 15),)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPasward()));
                          },
                          child: Text('forget password',style: TextStyle(color: Colors.white,fontSize: 14)))
                    ],
                  ),
              )
            ]),
                ),
          ),
        ),
      ),
    );
  }
}
