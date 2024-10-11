class ProblemsModel {
  final String titleko;
  final int level;

  ProblemsModel.fromJson(Map<String, dynamic> json)
      : titleko = json['titleKo'],
        level = json['level'];
}
