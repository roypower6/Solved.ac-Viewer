//문제풀이 정보 모델
class ClassStatisticsModel {
  final int classes;
  final int totalSolved;
  final int essentials;
  final int essentialSolved;

  ClassStatisticsModel.fromJson(Map<String, dynamic> json)
      : classes = json['class'],
        totalSolved = json['totalSolved'],
        essentials = json['essentials'],
        essentialSolved = json['essentialSolved'];
}
