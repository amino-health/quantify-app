import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/services/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  static String uEmail, uPassword;
  static bool done;

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

  String errorCode;
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
    } catch (error) {
      print(error.code);
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          errorCode = "Email already used. Go to login page.";
          return [null, errorCode];
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          errorCode = "Wrong email/password combination.";
          return [null, errorCode];
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          errorCode = "No user found with this email.";
          return [null, errorCode];
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          errorCode = "User disabled.";
          return [null, errorCode];
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          errorCode = "Too many requests to log into this account.";
          return [null, errorCode];
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          errorCode = "Server error, please try again later.";
          return [null, errorCode];
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          errorCode = "Email address is invalid.";
          return [null, errorCode];
        default:
          errorCode = "Login failed. Please try again.";
          return [null, errorCode];
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

      await DatabaseService(uid: user.uid).updateUserData(
          user.uid, user.email, true, '0', '0', '0', false, "male");

      await DatabaseService(uid: user.uid).createTrainingData(
          'Running', 'Sprint', DateTime.now(), 0, 3, false, 0);
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

  Future updatePassword({
    String email,
    String password,
    String newPassword,
  }) async {
    bool done = false;
    User user = _auth.currentUser;

    AuthCredential credentials =
        EmailAuthProvider.credential(email: email, password: password);

    UserCredential result =
        await user.reauthenticateWithCredential(credentials);

    await result.user.updatePassword(newPassword).then((_) {
      print("Succesfull changed password");
      done = true;
    });
    return done;
  }

  //Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Delete account and all the images
  Future deleteAccount() async {
    try {
      await _firestore
          .collection("userData")
          .doc(_auth.currentUser.uid)
          .collection("traning")
          .get()
          .then(
        (snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        },
      ).catchError((e) {
        print("Training: " + e);
      });
      await _firestore
          .collection("userData")
          .doc(_auth.currentUser.uid)
          .collection("mealData")
          .get()
          .then(
        (snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        },
      ).catchError((e) {
        print("Mealdata: " + e);
      });
      await _firestore
          .collection("userData")
          .doc(_auth.currentUser.uid)
          .collection("trainingDiary")
          .get()
          .then(
        (snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        },
      ).catchError((e) {
        print("TrainingDiary: " + e);
      });
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
    } catch (e) {
      print("NÅGOT annat fel");
      return await signOut();
    }
  }
}
