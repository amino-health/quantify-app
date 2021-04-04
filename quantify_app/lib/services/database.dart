import 'package:cloud_firestore/cloud_firestore.dart';

//refrence
class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userInfo = Firestore.instance.collection('info');

  Future updateUserInfo(
      String age, String weight, String height, bool consent) async {
    return await userInfo.document(uid).setData({
      'age': age,
      'weight': weight,
      'height': height,
      'consent': consent,
    });
  }

//stream of
  Stream<QuerySnapshot> get info {
    return userInfo.snapshots();
  }
}
