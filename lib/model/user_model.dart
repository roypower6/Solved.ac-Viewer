class UserModel {
  final String handle;
  final String profileImageUrl;
  final int solvedCount;
  final int rank;
  final int rating;
  final String backgroundId;
  final int maxStreak;
  final int stardusts;
  final int coins;
  final int tier;
  final String badgeId;

  UserModel.fromJson(Map<String, dynamic> json)
      : handle = json['handle'],
        profileImageUrl = json['profileImageUrl'],
        solvedCount = json['solvedCount'],
        rank = json['rank'],
        rating = json['rating'],
        backgroundId = json['backgroundId'],
        maxStreak = json['maxStreak'],
        stardusts = json['stardusts'],
        coins = json['coins'],
        tier = json['tier'],
        badgeId = json['badgeId'];
}
