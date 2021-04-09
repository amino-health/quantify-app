import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:quantify_app/models/info.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'
    as firebase_storage; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/screens/homeScreen.dart';

//refrence
//
//

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference userInfo =
      FirebaseFirestore.instance.collection('userData'); //collection of info

  Future<void> uploadImage(File imageFile, DateTime date, String note) async {
    String downloadURL;

    if (imageFile != null) {
      String fileName = Path.basename(imageFile.path).substring(14);
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/users/' + uid + '/mealImages/' + fileName);
      firebase_storage.UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        downloadURL = await storageRef.getDownloadURL();
      });
    }

    await userInfo.doc(uid).collection('mealData').doc().set({
      'imageRef': downloadURL,
      'note': note,
      'date': date.millisecondsSinceEpoch
    });
  }

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

  Future<dynamic> getUserImages() async {
    QuerySnapshot data = await userInfo.doc(uid).collection('mealData').get();
    return data.docs.toList();
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

  Future<void> removeMeal(MealData mealData) async {
    await userInfo
        .doc(uid)
        .collection('mealData')
        .doc(mealData.docId)
        .delete()
        .then((value) => print("doc deleted"))
        .catchError((error) => print(error));
    if (mealData.mealImageUrl != null) {
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .refFromURL(mealData.mealImageUrl);
      //print(storageRef);
      await storageRef.delete().catchError((error) => print(error));
    }
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
