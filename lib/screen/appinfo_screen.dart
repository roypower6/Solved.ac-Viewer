import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 정보'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '앱 설명',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '이 앱은 개인이 solvedac/unofficial-documentation의 비공식 API를 이용하여 만든 것으로, 해당 문서 제작자 측과 API 제작자 측, Solved.ac 공식 웹사이트와 백준 ONLINE JUDGE 웹사이트와는 아무런 관련이 없습니다.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '비공식 API 사용, 미숙한 앱 개발 실력으로 인해 앱 사용 중 오류가 발생할 수도 있습니다. 앱을 사용해 주셔서 감사합니다!',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '이 앱은 다음 언어를 통해 만들어졌습니다.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(EvaIcons.code),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Flutter (Dart)',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '개발자 정보',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(UniconsLine.github),
                SizedBox(width: 10),
                Text(
                  'roypower6',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(UniconsLine.fast_mail_alt),
                SizedBox(width: 10),
                Text(
                  'roy040707@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(UniconsLine.instagram),
                SizedBox(width: 10),
                Text(
                  'seunggi860',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Divider(color: Colors.grey),
                  Text(
                    'Thank you for using Solved.ac Viewer!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
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
