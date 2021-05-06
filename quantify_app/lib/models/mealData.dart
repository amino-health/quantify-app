class MealData {
  MealData(this.mealDescription, this.mealDate, this.mealImageUrl, this.docId,
      this.localPath);
  String mealDescription = "";
  DateTime mealDate;
  List<String> mealImageUrl;
  String docId;
  List<String> localPath;
}
