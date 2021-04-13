class TrainingDiary {
  final String uid;
  TrainingDiary({this.uid});
}

class TrainingDiaryData {
  String trainingid;
  String name;
  String description;
  String date;
  String duration;
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
