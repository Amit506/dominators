import 'package:firebase_auth/firebase_auth.dart';
import 'User.dart';

//All the firebase related auth service are defined here..

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // firebase instance

  Userr _userFromFireBaseUser(User user) {
    // to get the only user i.d
    return user != null ? Userr(uid: user.uid) : null;
  }

  Stream<Userr> get user {
    // to get stream of available user in firebase
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFireBaseUser(user));
  }

  Future signInAnom() async {
    // function to sign in anoymnsly
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future registerWithEmailPassword(String email, String password) async {
    // registering usng emai and password
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e);
    }
  }

  Future signInWithEmailPassword(String email, String password) async {
    // sign in using email and password
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e);
    }
  }

  Future signout() async {
    // to signout (give null value to user)
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
