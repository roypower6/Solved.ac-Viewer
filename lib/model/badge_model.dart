//뱃지 정보 모델
class BadgeModel {
  final String badgeImageUrl;
  final String displayName;
  final String displayDescription;

  BadgeModel.fromJson(Map<String, dynamic> json)
      : badgeImageUrl = json['badgeImageUrl'],
        displayName = json['displayName'],
        displayDescription = json['displayDescription'];
}
