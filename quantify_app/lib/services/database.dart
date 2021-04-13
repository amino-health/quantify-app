import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:quantify_app/models/info.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'
    as firebase_storage; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'package:quantify_app/models/training.dart';
import 'package:quantify_app/models/activityDiary.dart';
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
    DocumentReference doc = userInfo.doc(uid).collection('mealData').doc();
    if (imageFile != null) {
      String fileName = Path.basename(imageFile.path).substring(14);
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/users/' + uid + '/mealImages/' + fileName);
      firebase_storage.UploadTask uploadTask = storageRef.putFile(imageFile);
      uploadTask.whenComplete(() async {
        downloadURL = await storageRef.getDownloadURL();
        await doc.set({
          'imageRef': downloadURL,
          'localPath': imageFile.path,
          'note': note,
          'date': date.millisecondsSinceEpoch
        });
      });
    }
    await doc.set({
      'imageRef': downloadURL,
      'localPath': imageFile.path,
      'note': note,
      'date': date.millisecondsSinceEpoch
    });
  }

//För att updaterauser information, används när register och när updateras
  Future<void> updateUserData(
      String uid,
      String email,
      bool newuser,
      String age,
      String weight,
      String height,
      bool consent,
      String gender) async {
    return await userInfo.doc(uid).set({
      'uid': uid,
      'email': email,
      'newuser': newuser, //För att kunna veta om homescreen/eller andra
      'age': age,
      'weight': weight,
      'height': height,
      'consent': consent,
      'gender': gender,
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



  Future<void> removeMeal(MealData mealData) async {
    print(mealData.docId);

    if (mealData.mealImageUrl != null) {
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .refFromURL(mealData.mealImageUrl);
      await storageRef.delete().catchError((error) => print(error));
    }
    return await userInfo
        .doc(uid)
        .collection('mealData')
        .doc(mealData.docId)
        .delete();

  }

  Future<DocumentSnapshot> get userRegistered async {
    return userInfo.doc(uid).get();
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
        consent: snapshot.get('consent'),
        gender: snapshot.get('gender'));
  }

  List _userMealsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.toList();
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userInfo.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream get userMeals {
    return userInfo
        .doc(uid)
        .collection('mealData')
        .snapshots()
        .map(_userMealsFromSnapshot);
  }

  final CollectionReference trainingData =
      FirebaseFirestore.instance.collection('training');

  final CollectionReference trainingDiaryData =
      FirebaseFirestore.instance.collection('activityDiary');

  Future<void> createTrainingData(
      String trainingid,
      String name,
      String description,
      String date,
      String intensity,
      int listtype,
      bool inHistory) async {
    return await userInfo.doc(uid).collection('training').doc(trainingid).set({
      'trainingid': trainingid,
      'name': name,
      'description': description,
      'date': date,
      'intensity': intensity,
      'listtype': listtype,
      'inHistory': inHistory,
    });
  }

  Future<void> updateTrainingData(
      String trainingid,
      String name,
      String description,
      String date,
      String intensity,
      int listtype,
      bool inHistory) async {
    return await userInfo
        .doc(uid)
        .collection('training')
        .doc(trainingid)
        .update({
      'trainingid': trainingid,
      'date': date,
      'inHistory': inHistory,
    });
  }

  Future<void> removeActivity(String trainingid) async {
    return await userInfo
        .doc(uid)
        .collection('training')
        .doc(trainingid)
        .delete();
  }

  Stream<TrainingData> get trainingDatasave {
    return userInfo.doc(uid).snapshots().map(_trainingDataFromSnapshot);
  }

  TrainingData _trainingDataFromSnapshot(DocumentSnapshot snapshot) {
    return TrainingData(
        trainingid: snapshot.get('trainingid'),
        name: snapshot.get('name'),
        description: snapshot.get('description'),
        date: snapshot.get('date'),
        intensity: snapshot.get('date'),
        listtype: snapshot.get('listtype'));
  }

  Stream<TrainingDiaryData> get activityDiaryDatasave {
    return userInfo.doc(uid).snapshots().map(_activityDiaryDataFromSnapshot);
  }

  TrainingDiaryData _activityDiaryDataFromSnapshot(DocumentSnapshot snapshot) {
    return TrainingDiaryData(
        trainingid: snapshot.get('trainingid'),
        name: snapshot.get('name'),
        description: snapshot.get('description'),
        date: snapshot.get('date'),
        duration: snapshot.get('duration'),
        intensity: snapshot.get('intensity'));
  }
  //String key = firebase_storage.FirebaseStorage.instance.ref().child('users').child().push().getKey();

  Future<void> createTrainingDiaryData(
    String trainingid,
    String name,
    String description,
    String date,
    String duration,
    String intensity,
  ) async {
    return await userInfo.doc(uid).collection('trainingDiary').doc().set({
      'name': name,
      'description': description,
      'date': date,
      'duration': duration,
      'intensity': intensity,
    });
  }

  Future<void> removeDiaryItem(String diaryid) async {
    return await userInfo
        .doc(uid)
        .collection('trainingDiary')
        .doc(diaryid)
        .delete();
  }
}

