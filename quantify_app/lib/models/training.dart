class Training {
  final String uid;
  Training({this.uid});
}

class TrainingData {
  String trainingid;
  String name;
  String description;
  String date;
  int intensity;
  int listtype;
  bool inHistory;

  TrainingData(
      {this.trainingid,
      this.name,
      this.description,
      this.date,
      this.intensity,
      this.listtype,
      this.inHistory});
}
