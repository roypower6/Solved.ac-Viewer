class BackgroundModel {
  final String backgroundImageUrl;
  final dynamic fallbackbackgroundImageUrl;

  BackgroundModel.fromJson(Map<String, dynamic> json)
      : backgroundImageUrl = json['backgroundImageUrl'],
        fallbackbackgroundImageUrl = json['fallbackBackgroundImageUrl'];
}
