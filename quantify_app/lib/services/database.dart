import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:quantify_app/models/info.dart';
import 'package:quantify_app/models/user.dart';

//refrence
//
//

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userInfo =
      Firestore.instance.collection('info'); //colection of info

//För att updaterauser information, används när register och när updateras
  Future<void> updateUserData(String email, bool newuser, String age,
      String weight, String height, bool consent) async {
    return await userInfo.document(uid).setData({
      'email': email,
      'newuser': newuser, //För att kunna veta om homescreen/eller andra
      'age': age,
      'weight': weight,
      'height': height,
      'consent': consent,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        email: snapshot.data['email'],
        newuser: snapshot.data['newuser'],
        age: snapshot.data['age'],
        weight: snapshot.data['weight'],
        height: snapshot.data['height'],
        consent: snapshot.data['consent']);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userInfo.document(uid).snapshots().map(_userDataFromSnapshot);
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
