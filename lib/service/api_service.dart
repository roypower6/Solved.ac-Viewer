import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:solved_ac_browser/model/background_model.dart';
import 'package:solved_ac_browser/model/badge_model.dart';
import 'package:solved_ac_browser/model/statistics_model/class_statistics_model.dart';
import 'package:solved_ac_browser/model/coin_rate_model.dart';
import 'package:solved_ac_browser/model/statistics_model/level_statistics_model.dart';
import 'package:solved_ac_browser/model/organization_model.dart';
import 'package:solved_ac_browser/model/problem_num_search_model.dart';
import 'package:solved_ac_browser/model/problems_list_model.dart';
import 'package:solved_ac_browser/model/shop_item_model.dart';
import 'package:solved_ac_browser/model/statistics_model/tags_statistics_model.dart';
import 'package:solved_ac_browser/model/user_model.dart';

class SolvedacApi {
  static Future<UserModel?> getUserInfo(String handle) async {
    final url = Uri.parse('https://solved.ac/api/v3/user/show?handle=$handle');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final userInfo = await jsonDecode(response.body);
      final user = UserModel.fromJson(userInfo);
      return user;
    }
    return null; // Handle error scenarios
  }

  static Future<BackgroundModel?> getbackgroundInfo(String backgroundId) async {
    final url = Uri.parse(
        "https://solved.ac/api/v3/background/show?backgroundId=$backgroundId");
    final response = await http.get(
      url,
      headers: {'x-solvedac-language': 'ko'},
    );

    if (response.statusCode == 200) {
      final backgroundInfo = await jsonDecode(response.body);
      final background = BackgroundModel.fromJson(backgroundInfo);
      return background;
    }
    return null;
  }

  static Future<List<OrganizationModel>?> getOrganizationInfo(
      String handle) async {
    List<OrganizationModel> organizationInstances = [];
    final url =
        Uri.parse("https://solved.ac/api/v3/user/organizations?handle=$handle");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> organizations = await jsonDecode(response.body);
      for (var organization in organizations) {
        organizationInstances.add(OrganizationModel.fromJson(organization));
      }
      return organizationInstances;
    }
    return null;
  }

  static Future<List<ProblemsListModel>?> getProblemsInfo(String handle) async {
    List<ProblemsListModel> problemsInstances = [];
    final url =
        Uri.parse("https://solved.ac/api/v3/user/top_100?handle=$handle");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // items 리스트에서 각 항목을 ProblemsModel로 변환
      List<dynamic> items = data['items'];
      for (var item in items) {
        problemsInstances.add(ProblemsListModel.fromJson(item));
      }
      return problemsInstances;
    }
    return null;
  }

  static Future<BadgeModel?> getBadgeInfo(String badgeId) async {
    final url =
        Uri.parse("https://solved.ac/api/v3/badge/show?badgeId=$badgeId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final badgeInfo = await jsonDecode(response.body);
      final badge = BadgeModel.fromJson(badgeInfo);
      return badge;
    }
    return null;
  }

  static Future<List<TagStatisticsModel>> getTagsStaticsInfo(
      String handle) async {
    final url = Uri.parse(
        "https://solved.ac/api/v3/user/problem_tag_stats?handle=$handle");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['items'];

      // 태그가 없을 경우 빈 리스트 반환
      if (data.isEmpty) {
        return [];
      }

      return data.map((item) => TagStatisticsModel.fromJson(item)).toList();
    } else {
      // 오류 발생 시 빈 리스트 반환
      return [];
    }
  }

  static Future<List<LevelStatisticsModel>> getLevelStatisticsInfo(
      String handle) async {
    List<LevelStatisticsModel> statisticsInstances = [];
    final url =
        Uri.parse("https://solved.ac/api/v3/user/problem_stats?handle=$handle");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> statistics = await jsonDecode(response.body);
      for (var statistic in statistics) {
        statisticsInstances.add(LevelStatisticsModel.fromJson(statistic));
      }
      return statisticsInstances;
    }
    return [];
  }

  static Future<List<ClassStatisticsModel>> getClassStatisticsInfo(
      String handle) async {
    List<ClassStatisticsModel> statisticsInstances = [];
    final url =
        Uri.parse("https://solved.ac/api/v3/user/class_stats?handle=$handle");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> statistics = await jsonDecode(response.body);
      for (var statistic in statistics) {
        statisticsInstances.add(ClassStatisticsModel.fromJson(statistic));
      }
      return statisticsInstances;
    }
    return [];
  }

  static Future<List<ShopItemModel>> getShopItems() async {
    List<ShopItemModel> shopItems = [];
    final url = Uri.parse("https://solved.ac/api/v3/coins/shop/list");
    final response = await http.get(
      url,
      headers: {'x-solvedac-language': 'ko'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      for (var item in data) {
        shopItems.add(ShopItemModel.fromJson(item));
      }
      return shopItems;
    }
    return [];
  }

  static Future<CoinRateModel?> getCoinRate() async {
    final url = Uri.parse("https://solved.ac/api/v3/coins/exchange_rate");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final coinrate = CoinRateModel.fromJson(await jsonDecode(response.body));
      return coinrate;
    }
    return null;
  }

  static Future<List<ProblemNumSearchModel>> searchProblems({
    required String query,
    String direction = 'asc',
    int page = 1,
    String sort = 'title',
  }) async {
    final url = Uri.parse(
      'https://solved.ac/api/v3/search/problem?query=$query&direction=$direction&page=$page&sort=$sort',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((item) => ProblemNumSearchModel.fromJson(item)).toList();
    }
    return [];
  }
}
