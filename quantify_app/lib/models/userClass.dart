//DEFINE WHAT PROPERTIES USER going to have

class UserClass {
  final String uid;
  UserClass({this.uid}); // Turn f object
}

class UserData {
  final String uid;
  final String email;
  final bool newuser;
  final String age;
  final String weight;
  final String height;
  final bool consent;

  UserData(
      {this.uid,
      this.email,
      this.newuser,
      this.age,
      this.weight,
      this.height,
      this.consent});

  bool getNewUser() {
    return this.newuser;
  }
}