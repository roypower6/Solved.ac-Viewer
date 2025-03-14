//앱 상단 배경화면 정보 모델
class BackgroundModel {
  final String backgroundImageUrl;
  final dynamic fallbackbackgroundImageUrl;
  final String displayName;
  final String displayDescription;
  final String conditions;

  BackgroundModel.fromJson(Map<String, dynamic> json)
      : backgroundImageUrl = json['backgroundImageUrl'],
        fallbackbackgroundImageUrl = json['fallbackBackgroundImageUrl'],
        displayName = json['displayName'],
        displayDescription = json['displayDescription'],
        conditions = json['conditions'];
}
