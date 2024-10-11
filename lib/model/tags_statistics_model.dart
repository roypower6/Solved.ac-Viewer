class TagStatisticsModel {
  final String key;
  final int solved;
  final String displayName; // 태그 이름

  TagStatisticsModel.fromJson(Map<String, dynamic> json)
      : key = json['tag']['key'],
        solved = json['solved'],
        // displayNames에서 한국어 태그 이름이 있으면 우선 사용하고, 없으면 영어 태그 사용
        displayName = (json['tag']['displayNames'] as List).firstWhere(
            (name) => name['language'] == 'ko',
            orElse: () => {'name': json['tag']['key']})['name'];
}
