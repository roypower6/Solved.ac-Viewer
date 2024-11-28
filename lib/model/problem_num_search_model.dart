//
class ProblemNumSearchModel {
  final int problemId;
  final String titleKo;
  final bool isSolvable;
  final bool isPartial;
  final int acceptedUserCount;
  final int level;
  final double averageTries;
  final List<Tag> tags;

  ProblemNumSearchModel({
    required this.problemId,
    required this.titleKo,
    required this.isSolvable,
    required this.isPartial,
    required this.acceptedUserCount,
    required this.level,
    required this.averageTries,
    required this.tags,
  });

  factory ProblemNumSearchModel.fromJson(Map<String, dynamic> json) {
    var tagsFromJson = json['tags'] as List;
    List<Tag> tagList = tagsFromJson.map((tag) => Tag.fromJson(tag)).toList();

    return ProblemNumSearchModel(
      problemId: json['problemId'],
      titleKo: json['titleKo'],
      isSolvable: json['isSolvable'],
      isPartial: json['isPartial'],
      acceptedUserCount: json['acceptedUserCount'],
      level: json['level'],
      averageTries: json['averageTries'].toDouble(),
      tags: tagList,
    );
  }
}

class Tag {
  final String key;
  final List<DisplayName> displayNames;

  Tag({required this.key, required this.displayNames});

  factory Tag.fromJson(Map<String, dynamic> json) {
    var displayNamesFromJson = json['displayNames'] as List;
    List<DisplayName> displayNameList =
        displayNamesFromJson.map((name) => DisplayName.fromJson(name)).toList();

    return Tag(
      key: json['key'],
      displayNames: displayNameList,
    );
  }
}

class DisplayName {
  final String language;
  final String name;

  DisplayName.fromJson(Map<String, dynamic> json)
      : language = json['language'],
        name = json['name'];
}
