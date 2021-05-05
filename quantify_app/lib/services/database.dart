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
      FirebaseFirestore.instance.collection('userData');
  final CollectionReference basicTraining = FirebaseFirestore.instance
      .collection('basicTraining'); //collection of info

  Future<void> uploadImage(
      List<File> imageList, DateTime date, String note) async {
    String downloadURL;
    imageList.sort((a, b) => a.path == '' ? 1 : 0);

    List<String> urlArray = [];
    List<String> localPathArray = [];
    //File firstFile = imageList[0];

    DocumentReference doc = userInfo.doc(uid).collection('mealData').doc();
    for (File image in imageList) {
      if (image.path != '') {
        String fileName = Path.basename(image.path).substring(14);
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/users/' + uid + '/mealImages' + '/' + fileName);

        localPathArray.add(image.path);
        firebase_storage.UploadTask uploadTask = storageRef.putFile(image);
        uploadTask.whenComplete(() async {
          downloadURL = await storageRef.getDownloadURL();
          urlArray.add(downloadURL);

          await doc.update({'imageRef': urlArray});
        });
      }
    }

    await doc.set({
      'imageRef': urlArray,
      'localPath': localPathArray != [] ? localPathArray : [],
      'note': note,
      'date': date.millisecondsSinceEpoch
    });
  }

//För att updaterauser information, används när register och när updateras
  Future<void> updateUserData(
      String name,
      String uid,
      String email,
      bool newuser,
      int age,
      String weight,
      String height,
      bool consent,
      String gender) async {
    return await userInfo.doc(uid).set({
      'name': name,
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

  Future<void> editMeal(docId, List<File> imageList, DateTime newDate, newNote,
      imageChanged) async {
    print('list in edit is $imageList');
    List<String> urlArray = [];
    List<String> localPathArray = [];
    for (File newImage in imageList) {
      String downloadURL;
      if (imageChanged && newImage != null) {
        localPathArray.add(newImage.path);
        DocumentSnapshot mealDoc =
            await userInfo.doc(uid).collection('mealData').doc(docId).get();
        List<String> urlList = mealDoc.get('imageRef').cast<String>();

        for (String url in urlList) {
          if (url != null) {
            firebase_storage.Reference storageRef =
                firebase_storage.FirebaseStorage.instance.refFromURL(url);
            await storageRef.delete().catchError((error) => print(error));
          }
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
          urlArray.add(downloadURL);
          await doc.update({'imageRef': urlArray});
        });
      }
      if (imageChanged) {
        await userInfo.doc(uid).collection('mealData').doc(docId).update({
          'imageRef': urlArray,
          'localPath': localPathArray.length != 0 ? localPathArray : null,
          'note': newNote,
          'date': newDate.millisecondsSinceEpoch
        });
      } else {
        await userInfo
            .doc(uid)
            .collection('mealData')
            .doc(docId)
            .update({'note': newNote, 'date': newDate.millisecondsSinceEpoch});
      }
    }
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
    for (int i = 0; i < mealData.mealImageUrl.length; i++) {
      if (mealData.mealImageUrl[i] != null) {
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .storage
            .refFromURL(mealData.mealImageUrl[i]);
        //print(storageRef);
        //print(mealData.mealImageUrl);
        await storageRef.delete().catchError((error) => print(error));
      }
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
    String name;
    try {
      name = snapshot.get('name');
    } catch (e) {
      name = "";
    }
    return UserData(
        name: name,
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

  Stream get allActivities {
    //  Stream basicTrainingData =
    //   basicTraining.snapshots().map(_basicActivityFromSnapshot);
    Stream activityData = userInfo
        .doc(uid)
        .collection('training')
        .snapshots()
        .map(_userActivityFromSnapshot);

    return activityData;
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
      String trainingid,
      String name,
      String description,
      DateTime date,
      int intensity,
      int listtype,
      int category,
      {bool inHistory}) async {
    //print("In history is $inHistory");
    if (inHistory != null) {
      return await userInfo
          .doc(uid)
          .collection('training')
          .doc(trainingid)
          .set({
        'name': name,
        'description': description,
        'date': date.millisecondsSinceEpoch,
        'intensity': intensity,
        'listtype': listtype,
        'inHistory': inHistory,
        'category': category
      });
    } else {
      return await userInfo
          .doc(uid)
          .collection('training')
          .doc(trainingid)
          .update({
        'name': name,
        'description': description,
        'date': date.millisecondsSinceEpoch,
        'intensity': intensity,
        'listtype': listtype,
        'category': category
      });
    }
  }

  Future<void> createBasicTrainingData() async {
    bool existed = false;
    //print('In create function');
    FirebaseFirestore.instance
        .collection("basicTraining")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((basic) {
        FirebaseFirestore.instance
            .collection("userData")
            .doc(uid)
            .collection('training')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((intraining) {
            if (intraining.id == basic.id) {
              // print(intraining.id);
              // print(basic.id);
              // print('item already existed');
              existed = true;
            }
          });
          //print(basic['name']);
          if (!existed) {
            createTrainingData(
                basic.id,
                basic['name'],
                basic['description'],
                DateTime.now(),
                basic['intensity'],
                basic['listtype'],
                basic['category'],
                inHistory: basic['inHistory']);
          }
          existed = false;
        });
      });
    });
    print('leaving');
  }

  Future<void> copyTrainingData() async {
    print('In copy function');
    FirebaseFirestore.instance
        .collection("basicTraining")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        createTrainingData(
          result.id,
          result['name'],
          result['description'],
          DateTime.now(),
          result['intensity'],
          result['listtype'],
          result['category'],
        );

        print(result['name']);
      });
    });
    print('leaving');
  }

  Future<void> updateTrainingData(String trainingid,
      {String name,
      String description,
      DateTime date,
      int intensity,
      int listtype,
      bool inHistory,
      int category}) async {
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
