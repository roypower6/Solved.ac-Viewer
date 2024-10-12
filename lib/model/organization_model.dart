class OrganizationModel {
  final String name;
  final int rating;
  final int userCount;
  final String type;
  final int voteCount;
  final int solvedCount;

  OrganizationModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        rating = json['rating'],
        userCount = json['userCount'],
        type = json['type'],
        voteCount = json['voteCount'],
        solvedCount = json['solvedCount'];
}
