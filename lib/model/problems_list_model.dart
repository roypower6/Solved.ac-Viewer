//상위 100문제 리스트 모델
class ProblemsListModel {
  final int problemId;
  final String titleko;
  final int level;
  final int acceptedUserCount;
  final double averageTries;

  ProblemsListModel.fromJson(Map<String, dynamic> json)
      : problemId = json['problemId'],
        titleko = json['titleKo'],
        level = json['level'],
        acceptedUserCount = json['acceptedUserCount'],
        averageTries = json['averageTries'];
}
