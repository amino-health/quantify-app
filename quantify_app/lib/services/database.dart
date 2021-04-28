import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:quantify_app/models/info.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'
    as firebase_storage; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'package:quantify_app/models/training.dart';
import 'package:quantify_app/models/activityDiary.dart';
import 'package:quantify_app/models/userClass.dart';

import 'package:quantify_app/models/mealData.dart';
import 'package:quantify_app/screens/graphs.dart';

import 'package:stream_transform/stream_transform.dart';

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
        await doc.update({'imageRef': downloadURL});
      });
    }
    await doc.set({
      'imageRef': downloadURL,
      'localPath': imageFile != null ? imageFile.path : null,
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

  Future<void> editMeal(
      docId, newImage, DateTime newDate, newNote, imageChanged) async {
    String downloadURL;
    if (imageChanged && newImage != null) {
      DocumentSnapshot mealDoc =
          await userInfo.doc(uid).collection('mealData').doc(docId).get();
      String url = mealDoc.get('imageRef');

      if (url != null) {
        firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.refFromURL(url);
        await storageRef.delete().catchError((error) => print(error));
      }
      DocumentReference doc =
          userInfo.doc(uid).collection('mealData').doc(docId);
      String fileName = Path.basename(newImage.path).substring(14);
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/users/' + uid + '/mealImages/' + fileName);
      firebase_storage.UploadTask uploadTask = storageRef.putFile(newImage);
      uploadTask.whenComplete(() async {
        downloadURL = await storageRef.getDownloadURL();
        await doc.update({'imageRef': downloadURL});
      });
    }
    await userInfo.doc(uid).collection('mealData').doc(docId).update({
      'imageRef': downloadURL,
      'localPath': newImage != null ? newImage.path : null,
      'note': newNote,
      'date': newDate.millisecondsSinceEpoch
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
    if (mealData.mealImageUrl != null) {
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .storage
          .refFromURL(mealData.mealImageUrl);
      print(storageRef);
      print(mealData.mealImageUrl);
      await storageRef.delete().catchError((error) => print(error));
    }
    return await userInfo
        .doc(uid)
        .collection('mealData')
        .doc(mealData.docId)
        .delete();
  }

  Future updateEmail(String email) async {
    return await userInfo.doc(uid).set({'email': email});
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

  List _userActivityFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.toList();
  }

  Stream get userDiary {
    Stream mealData = userInfo
        .doc(uid)
        .collection('mealData')
        .snapshots()
        .map(_userMealsFromSnapshot);
    Stream activityData = userInfo
        .doc(uid)
        .collection('trainingDiary')
        .snapshots()
        .map(_userActivityFromSnapshot);

    return activityData.combineLatestAll([mealData]);
  }

  final CollectionReference trainingData =
      FirebaseFirestore.instance.collection('training');

  final CollectionReference trainingDiaryData =
      FirebaseFirestore.instance.collection('activityDiary');

  Future<void> createTrainingData(
      String name,
      String description,
      DateTime date,
      int intensity,
      int listtype,
      bool inHistory,
      int category) async {
    return await userInfo.doc(uid).collection('training').doc().set({
      'name': name,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'intensity': intensity,
      'listtype': listtype,
      'inHistory': inHistory,
      'category': category
    });
  }

  Future<void> updateTrainingData(
      String trainingid,
      String name,
      String description,
      DateTime date,
      int intensity,
      int listtype,
      bool inHistory,
      int category) async {
    return await userInfo
        .doc(uid)
        .collection('training')
        .doc(trainingid)
        .update({
      'trainingid': trainingid,
      'date': date.millisecondsSinceEpoch,
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
        listtype: snapshot.get('listtype'),
        category: snapshot.get('category'));
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
        intensity: snapshot.get('intensity'),
        category: snapshot.get('category'));
  }
  //String key = firebase_storage.FirebaseStorage.instance.ref().child('users').child().push().getKey();

  Future<void> createTrainingDiaryData(
    String name,
    String description,
    DateTime date,
    Duration duration,
    int intensity,
    int category,
  ) async {
    return await userInfo.doc(uid).collection('trainingDiary').doc().set({
      'name': name,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'duration': duration.inMilliseconds,
      'intensity': intensity,
      'category': category
    });
  }

  Future<void> updateTrainingDiaryData(
    String trainingid,
    String name,
    String description,
    DateTime date,
    Duration duration,
    int intensity,
    int category,
  ) async {
    return await userInfo
        .doc(uid)
        .collection('trainingDiary')
        .doc(trainingid)
        .update({
      'trainingid': trainingid,
      'date': date.millisecondsSinceEpoch,
      'duration': duration.inMilliseconds,
      'name': name,
      'description': description,
      'intensity': intensity,
      'category': category
    });
  }

  Future<void> removeDir({String ref = ""}) async {
    print("Hello: " + ref);
    firebase_storage.ListResult result;
    if (ref == "") {
      result = await firebase_storage.FirebaseStorage.instance
          .ref('images/users/' + uid)
          .listAll();
    } else {
      result = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child(ref)
          .listAll();
    }

    result.items.forEach((firebase_storage.Reference ref) async {
      print('Found file: ${ref.fullPath}');
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child(ref.fullPath)
          .delete();
    });

    result.prefixes.forEach((firebase_storage.Reference ref) async {
      await removeDir(ref: ref.fullPath);
    });
    print("endddd");
  }

  Future<void> removeDiaryItem(String diaryid) async {
    return await userInfo
        .doc(uid)
        .collection('trainingDiary')
        .doc(diaryid)
        .delete();
  }

  Future<bool> updateGlucose(List<GlucoseData> list) async {
    bool result = true;
    try {
      list.forEach((element) async {
        await userInfo
            .doc(uid)
            .collection('glucose')
            .doc(element.time.millisecondsSinceEpoch.toString())
            .set({
          'date': element.time.millisecondsSinceEpoch,
          'glucose': element.glucoseVal,
        });
      });
    } catch (e) {
      result = false;
    }
    return result;
  }
}

class CombinedData {
  final List to;
  final List from;

  CombinedData(this.to, this.from);
}
