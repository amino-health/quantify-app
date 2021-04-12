import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/services/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
          .updateUserData(user.uid, user.email, true, '0', '0', '0', false);
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
          .updateUserData(user.uid, user.email, true, '0', '0', '0', false);
      await DatabaseService(uid: user.uid)
          .createTrainingData('0', 'Running', 'Sprint', '', '', 3, false);
    } catch (error) {
      print('HEJ');
      print(error.toString());
      return null;
    }
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

  Future<void> listExample() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images/users')
        .listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });

    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });
  }

  // Delete account and all the images
  Future deleteAccount() async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
              'images/users/VqFaeyP6LVWrhBtI3S4PGgCtzTz1/mealImages/slkjdfkls/hello-world.txt')
          .delete();
      print("Done");
    } catch (e) {
      print(e);
    }

    /*try {
      await _firestore
          .collection("userData")
          .doc(_auth.currentUser.uid)
          .delete();
      return await _auth.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
        return await signOut();
      }
    }*/
  }
}
