class PreviousMatchModel {
  int? finalScore;
  String? id;

  PreviousMatchModel.fromMap(previousMatchMap) {
    finalScore = previousMatchMap['final_score'];
    id = previousMatchMap['id'];
  }
}
