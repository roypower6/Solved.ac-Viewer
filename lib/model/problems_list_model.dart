class ProblemsModel {
  final int problemId;
  final String titleko;
  final int level;

  ProblemsModel.fromJson(Map<String, dynamic> json)
      : problemId = json['problemId'],
        titleko = json['titleKo'],
        level = json['level'];
}
