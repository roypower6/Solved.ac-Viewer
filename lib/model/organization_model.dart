class OrganizationModel {
  final String name;
  final int rating;
  final int userCount;

  OrganizationModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        rating = json['rating'],
        userCount = json['userCount'];
}
