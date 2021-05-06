//DEFINE WHAT PROPERTIES USER going to have

class UserClass {
  final String uid;
  UserClass({this.uid}); // Turn f object
}

class UserData {
  final String name;
  final String uid;
  final String email;
  final bool newuser;
  final int age;
  final String weight;
  final String height;
  final bool consent;
  final String gender;

  UserData(
      {this.name,
      this.uid,
      this.email,
      this.newuser,
      this.age,
      this.weight,
      this.height,
      this.consent,
      this.gender});

  bool getNewUser() {
    return this.newuser;
  }
}
