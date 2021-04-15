import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/services/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  static String uEmail, uPassword;
  static bool done;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final GoogleSignIn _googleSignUn = new GoogleSignIn();

//Create user object based on firebase
//Get "userid"
  UserClass _userFromFirebaseUser(User user) {
    // User we take in
    return user != null
        ? UserClass(uid: user.uid)
        : null; //If user not null return userid
  }

  //auth change user stream
  //Setting up stream so everytime a user
  //signs in/signs out get response from stream
  //Null or not
  Stream<UserClass> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

//Sign in
  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim()); //from firebase library
      User user = result.user;
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

  Future changeEmail(String email) async {
    try {
      dynamic user = _auth.currentUser;

      dynamic response = await user.updateEmail(email);
      await DatabaseService(uid: user.uid).updateEmail(email);
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> signInWithGoogle() async {
    User user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);

        user = userCredential.user;
        print(user);
      } catch (e) {
        print("ERROR i google");
        user = null;
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    final snapShot = await DatabaseService(uid: user.uid).userRegistered;

    if (snapShot == null || !snapShot.exists) {
      await DatabaseService(uid: user.uid)
          .updateUserData(user.uid, user.email, true, '0', '0', '0', false, '');
      return _userFromFirebaseUser(user);
    }

    return user;
  }

//em
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user; //Grab user from
      //skapar nytt dokument kopplat till spesifikt user with this uid
      await DatabaseService(uid: user.uid)
          .updateUserData(user.uid, user.email, true, '0', '0', '0', false, '');
      await DatabaseService(uid: user.uid)
          .createTrainingData('0', 'Running', 'Sprint', '', '', 3, false);
    } catch (error) {
      print('HEJ');
      print(error.toString());
      return null;
    }
  }

  Future updateEmail({
    String email,
    String password,
    String newEmail,
  }) async {
    bool done = false;
    User user = _auth.currentUser;
    AuthCredential credentials =
        EmailAuthProvider.credential(email: email, password: password);

    UserCredential result =
        await user.reauthenticateWithCredential(credentials);

    await result.user.updateEmail(newEmail).then((_) {
      print("Succesfull changed email");
      done = true;
    });
    return done;
  }

//Sign in with google

  //Sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
