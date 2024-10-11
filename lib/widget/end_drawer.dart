import 'package:flutter/material.dart';
import 'package:solved_ac_browser/screen/appinfo_screen.dart';
import 'package:solved_ac_browser/screen/problem_search_screen.dart';
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
            const Divider(
              color: Colors.grey,
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.pie_chart),
              title: const Text("문제풀이 통계"),
              children: [
                ListTile(
                  leading: const Icon(Icons.tag_sharp),
                  title: const Text("태그별 문제풀이 통계"),
                  onTap: () {
                    Navigator.pop(context); // Drawer 닫기
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StatisticsScreen(handle: currentHandle),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart_outlined),
                  title: const Text("난이도별 문제풀이 통계"),
                  onTap: () {
                    Navigator.pop(context); // Drawer 닫기
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LevelStatisticsScreen(handle: currentHandle),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.star_rate),
                  title: const Text("클래스별 문제풀이 통계"),
                  onTap: () {
                    Navigator.pop(context); // Drawer 닫기
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClassStatisticsScreen(handle: currentHandle),
                      ),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("백준 문제 검색하기"),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProblemSearchScreen(), // Navigate to the ShopScreen
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_rounded),
              title: const Text("코인샵"),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ShopScreen(), // Navigate to the ShopScreen
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("앱 정보"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppInfoScreen()));
              },
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
            Expanded(child: Container()), // 빈 공간을 차지하여 하단으로 밀기
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
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
                          'App Version: 1.0.0',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Developed by Rhee Seung-gi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '© 2024 Rhee Seung-gi. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
