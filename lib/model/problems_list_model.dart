//상위 100문제 리스트 모델
class ProblemsListModel {
  final int problemId;
  final String titleko;
  final int level;

  ProblemsListModel.fromJson(Map<String, dynamic> json)
      : problemId = json['problemId'],
        titleko = json['titleKo'],
        level = json['level'];
}
