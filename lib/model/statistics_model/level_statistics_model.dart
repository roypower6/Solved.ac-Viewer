//레벨별 문제 수 모델
class LevelStatisticsModel {
  final int level;
  final int solved;

  LevelStatisticsModel.fromJson(Map<String, dynamic> json)
      : level = json['level'],
        solved = json['solved'];
}
