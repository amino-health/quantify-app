class TrainingDiary {
  final String uid;
  TrainingDiary({this.uid});
}

class TrainingDiaryData {
  String trainingid;
  String name;
  String description;
  DateTime date;
  Duration duration;
  int intensity;
  int category;

  TrainingDiaryData(
      {this.trainingid,
      this.name,
      this.description,
      this.date,
      this.duration,
      this.intensity,
      this.category});
}
