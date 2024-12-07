import 'package:flutter/material.dart';
import 'package:solved_ac_browser/screen/appinfo_screen.dart';
import 'package:solved_ac_browser/screen/search_screen/problem_name_search_screen.dart';
import 'package:solved_ac_browser/screen/search_screen/problem_num_search_screen.dart';
import 'package:solved_ac_browser/screen/statistics_screen/class_statistics_screen.dart';
import 'package:solved_ac_browser/screen/login_screen.dart';
import 'package:solved_ac_browser/screen/statistics_screen/tags_statistics_screen.dart';
import 'package:solved_ac_browser/screen/statistics_screen/level_statistics_screen.dart';
import 'package:solved_ac_browser/screen/shop_screen.dart';
import 'package:restart_app/restart_app.dart';

class EndDrawer extends StatelessWidget {
  final String currentHandle;
  final Future<void> Function() clearPrefs;

  const EndDrawer({
    super.key,
    required this.currentHandle,
    required this.clearPrefs,
  });

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                currentHandle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.grey, thickness: 3),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ExpansionTile(
              leading: const Icon(Icons.pie_chart),
              title: const Text("문제풀이 통계"),
              children: [
                ListTile(
                  leading: const Icon(Icons.tag_sharp),
                  title: const Text("태그별 문제풀이 통계"),
                  onTap: () => _navigateTo(
                      context, StatisticsScreen(handle: currentHandle)),
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart_outlined),
                  title: const Text("난이도별 문제풀이 통계"),
                  onTap: () => _navigateTo(
                      context, LevelStatisticsScreen(handle: currentHandle)),
                ),
                ListTile(
                  leading: const Icon(Icons.star_rate),
                  title: const Text("클래스별 문제풀이 통계"),
                  onTap: () => _navigateTo(
                      context, ClassStatisticsScreen(handle: currentHandle)),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.search_rounded),
              title: const Text("문제 검색"),
              children: [
                ListTile(
                  leading: const Icon(Icons.format_list_numbered_rounded),
                  title: const Text("백준 문제 번호로 검색하기"),
                  onTap: () =>
                      _navigateTo(context, const ProblemNumSearchScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.abc_rounded),
                  title: const Text("백준 문제 이름으로 검색하기"),
                  onTap: () =>
                      _navigateTo(context, const ProblemNameSearchScreen()),
                )
              ],
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_rounded),
              title: const Text("코인샵"),
              onTap: () => _navigateTo(context, const ShopScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("앱 정보"),
              onTap: () => _navigateTo(context, const AppInfoScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("로그아웃"),
              onTap: () async {
                await clearPrefs();
                LoginScreenState().loadSavedId();
                Restart.restartApp();
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(color: Colors.grey),
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey),
                      SizedBox(width: 10),
                      Text(
                        'App Version: 1.0.6',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Developed by Rhee',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '© 2024 Rhee. All rights reserved.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
