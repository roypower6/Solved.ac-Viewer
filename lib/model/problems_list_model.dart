import 'package:solved_ac_browser/model/problem_name_search_model.dart';

class ProblemsListModel {
  final int problemId;
  final String titleko;
  final int level;
  final int acceptedUserCount;
  final double averageTries;
  final List<TagModel> tags;

  ProblemsListModel.fromJson(Map<String, dynamic> json)
      : problemId = json['problemId'],
        titleko = json['titleKo'],
        level = json['level'],
        acceptedUserCount = json['acceptedUserCount'],
        averageTries = json['averageTries'],
        tags = (json['tags'] as List?)
                ?.map((tag) => TagModel.fromJson(tag))
                .toList() // 태그 리스트로 변환
            ??
            []; // 없으면 빈 리스트로 초기화
}
