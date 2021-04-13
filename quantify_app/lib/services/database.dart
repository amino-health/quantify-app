import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:quantify_app/models/info.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'
    as firebase_storage; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'package:quantify_app/models/training.dart';

import 'package:quantify_app/models/userClass.dart';

//refrence
//
//

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userInfo =
      FirebaseFirestore.instance.collection('userData'); //collection of info

  Future<void> uploadImage(File imageFile, DateTime date, String note) async {
    String fileName = Path.basename(imageFile.path).substring(14);
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images/users/' + uid + '/mealImages/' + fileName);
    firebase_storage.UploadTask uploadTask = storageRef.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    await userInfo.doc(uid).collection('mealData').doc().set({
      'imageRef': 'images/users/' + uid + 'mealImages/' + fileName,
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

  Future<void> updateUserweight(String weight) async {
    return await userInfo.doc(uid).set({
      'weight': weight,
    });
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

  Stream<UserData> get userData {
    return userInfo.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  final CollectionReference trainingData =
      FirebaseFirestore.instance.collection('training');

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
}

/*
FirebaseFirestore.instance.collection
  List<TrainingData> _trainingListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((trainingid) {
      return TrainingData(
          trainingid: trainingid.get('trainingid') ?? '',
          name: trainingid.get('name') ?? '',
          description: trainingid.get('description') ?? '',
          date: trainingid.get('date') ?? '',
          intensity: trainingid.get('intensity') ?? '');
    }).toList();
  }
  

  Stream<List<TrainingData>> get trainings {
    return userInfo.snapshots().map(_trainingListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userInfo.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<DocumentSnapshot> get userRegistered async {
    return userInfo.doc(uid).get();
  }
}
*/
