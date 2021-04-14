class TrainingDiary {
  final String uid;
  TrainingDiary({this.uid});
}

class TrainingDiaryData {
  String trainingid;
  String name;
  String description;
  DateTime date;
  DateTime duration;
  int intensity;

  TrainingDiaryData({
    this.trainingid,
    this.name,
    this.description,
    this.date,
    this.duration,
    this.intensity,
  });
}
