import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:quantify_app/models/info.dart';
import 'package:quantify_app/models/userClass.dart';

//refrence
//
//

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userInfo =
      FirebaseFirestore.instance.collection('userData'); //colection of info

//För att updaterauser information, används när register och när updateras
  Future<void> updateUserData(String uid, String email, bool newuser,
      String age, String weight, String height, bool consent) async {
    return await userInfo.doc(uid).set({
      'uid': uid,
      'email': email,
      'newuser': newuser, //För att kunna veta om homescreen/eller andra
      'age': age,
      'weight': weight,
      'height': height,
      'consent': consent,
    });
  }

  Future<void> updateUserProfile(
      String birth, String weight, String height, String gender) async {
    return await userInfo.doc(uid).set({
      'birth': birth,
      'weight': weight,
      'height': height,
      'gender': gender,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    print("Snapshot: " + snapshot.data.toString());
    return UserData(
        uid: uid,
        email: snapshot.get('email'),
        newuser: snapshot.get('newuser'),
        age: snapshot.get('age'),
        weight: snapshot.get('weight'),
        height: snapshot.get('height'),
        consent: snapshot.get('consent'));
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userInfo.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<DocumentSnapshot> get userRegistered async {
    return userInfo.doc(uid).get();
  }
}

/*

------------------
 final String uid;
  DatabaseService({this.uid});

  final CollectionReference profileList =
      Firestore.instance.collection('profileInfo');

//Denna används för att skapa userdatan!
  Future<void> createUserData(bool newuser, String age, String weight,
      String height, bool consent) async {
    return await profileList.document(uid).setData({
      'newuser': newuser,
      'age': age,
      'weight': weight,
      'height': height,
      'consent': consent
    });
  }

  Future updateUserList(bool newuser, String age, String weight, String height,
      bool consent) async {
    return await profileList.document(uid).updateData({
      'newuser': newuser,
      'age': age,
      'weight': weight,
      'height': height,
      'consent': consent
    });
  }

  Future getUsersList() async {
    List itemsList = [];
    try {
      await profileList.getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
*/
