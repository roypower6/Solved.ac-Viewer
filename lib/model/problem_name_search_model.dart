class ProblemModel {
  final int problemId;
  final String titleKo;
  final List<TitleModel> titles;
  final bool isSolvable;
  final bool isPartial;
  final int acceptedUserCount;
  final int level;
  final int votedUserCount;
  final bool sprout;
  final bool givesNoRating;
  final bool isLevelLocked;
  final double averageTries;
  final bool official;
  final List<TagModel> tags;

  ProblemModel({
    required this.problemId,
    required this.titleKo,
    required this.titles,
    required this.isSolvable,
    required this.isPartial,
    required this.acceptedUserCount,
    required this.level,
    required this.votedUserCount,
    required this.sprout,
    required this.givesNoRating,
    required this.isLevelLocked,
    required this.averageTries,
    required this.official,
    required this.tags,
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) {
    return ProblemModel(
      problemId: json['problemId'],
      titleKo: json['titleKo'],
      titles: (json['titles'] as List)
          .map((title) => TitleModel.fromJson(title))
          .toList(),
      isSolvable: json['isSolvable'],
      isPartial: json['isPartial'],
      acceptedUserCount: json['acceptedUserCount'],
      level: json['level'],
      votedUserCount: json['votedUserCount'],
      sprout: json['sprout'],
      givesNoRating: json['givesNoRating'],
      isLevelLocked: json['isLevelLocked'],
      averageTries: json['averageTries'].toDouble(),
      official: json['official'],
      tags:
          (json['tags'] as List).map((tag) => TagModel.fromJson(tag)).toList(),
    );
  }
}

class TitleModel {
  final String language;
  final String languageDisplayName;
  final String title;
  final bool isOriginal;

  TitleModel({
    required this.language,
    required this.languageDisplayName,
    required this.title,
    required this.isOriginal,
  });

  factory TitleModel.fromJson(Map<String, dynamic> json) {
    return TitleModel(
      language: json['language'],
      languageDisplayName: json['languageDisplayName'],
      title: json['title'],
      isOriginal: json['isOriginal'],
    );
  }
}

class TagModel {
  final String key;
  final bool isMeta;
  final int bojTagId;
  final int problemCount;
  final List<DisplayNameModel> displayNames;

  TagModel({
    required this.key,
    required this.isMeta,
    required this.bojTagId,
    required this.problemCount,
    required this.displayNames,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      key: json['key'],
      isMeta: json['isMeta'],
      bojTagId: json['bojTagId'],
      problemCount: json['problemCount'],
      displayNames: (json['displayNames'] as List)
          .map((name) => DisplayNameModel.fromJson(name))
          .toList(),
    );
  }
}

class DisplayNameModel {
  final String language;
  final String name;
  final String short;

  DisplayNameModel({
    required this.language,
    required this.name,
    required this.short,
  });

  factory DisplayNameModel.fromJson(Map<String, dynamic> json) {
    return DisplayNameModel(
      language: json['language'],
      name: json['name'],
      short: json['short'],
    );
  }
}
