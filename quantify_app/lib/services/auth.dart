import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quantify_app/models/user.dart';
import 'package:quantify_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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

//Sign in email password
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

//Register email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user; //Grab user from
      //crete new doc for user with this uid
      // await DatabaseService(uid: user.uid).updateUserInfo('0', '0', '0', false);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print('HEJ');
      print(error.toString());
      return null;
    }
  }

//Sign in with google
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
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
}
