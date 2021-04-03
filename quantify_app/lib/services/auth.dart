import 'package:firebase_auth/firebase_auth.dart';
import 'package:quantify_app/models/user.dart';
import 'package:quantify_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//Create user object based on firebase
//Get "userid"
  User _userFromFirebaseUser(FirebaseUser user) {
    // User we take in
    return user != null
        ? User(uid: user.uid)
        : null; //If user not null return userid
  }

  //auth change user stream
  //Setting up stream so everytime a user
  //signs in/signs out get response from stream
  //Null or not
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//Sign in
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim()); //from firebase library
      FirebaseUser user = result.user;
      print(result);
      print(user);
      return user;
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          return e.message;
          break;
        default:
          return null;
      }
    }
  }

//Register
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user; //Grab user from
      //crete new doc for user with this uid
      await DatabaseService(uid: user.uid).updateUserInfo('0', '0', '0', false);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print('HEJ');
      print(error.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
