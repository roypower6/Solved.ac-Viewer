import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:solved_ac_browser/model/problem_search_model.dart';
import 'package:solved_ac_browser/service/admob_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProblemSearchScreen extends StatefulWidget {
  const ProblemSearchScreen({super.key});

  @override
  ProblemSearchScreenState createState() => ProblemSearchScreenState();
}

class ProblemSearchScreenState extends State<ProblemSearchScreen> {
  final TextEditingController _problemIdController = TextEditingController();
  Future<ProblemModel?>? _problemFuture;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<ProblemModel?> fetchProblem(int problemId) async {
    final url =
        Uri.parse('https://solved.ac/api/v3/problem/show?problemId=$problemId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProblemModel.fromJson(json);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("백준 문제 검색")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _problemIdController,
                  decoration: const InputDecoration(
                    labelText: "문제 ID",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final problemId = int.tryParse(_problemIdController.text);
                    if (problemId != null) {
                      setState(() {
                        _problemFuture = fetchProblem(problemId);
                      });
                    }
                  },
                  child: const Text("검색"),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _problemFuture != null
                      ? FutureBuilder<ProblemModel?>(
                          future: _problemFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError ||
                                snapshot.data == null) {
                              return const Text(
                                "문제를 찾을 수 없습니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              );
                            } else {
                              final problem = snapshot.data!;
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      problem.titleKo,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Mapping level to tier name and color
                                    Row(
                                      children: [
                                        const Text(
                                          "문제 티어: ",
                                          style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${probTierMapping[problem.level]}",
                                          style: TextStyle(
                                            shadows: const [
                                              Shadow(
                                                color: Colors.grey,
                                                offset: Offset(1.5, 1.5),
                                                blurRadius: 6,
                                              ),
                                            ],
                                            fontSize: 25,
                                            color:
                                                probTierColors[problem.level],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "성공한 유저 수: ${problem.acceptedUserCount}명",
                                      style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "평균 시도 횟수: ${problem.averageTries.toStringAsFixed(2)}회",
                                      style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "태그:",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      children: problem.tags.map((tag) {
                                        return Chip(
                                          label: Text(
                                            tag.displayNames.first.name,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          final url =
                                              'https://www.acmicpc.net/problem/${problem.problemId}';
                                          launchUrl(Uri.parse(url));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 40),
                                          decoration: BoxDecoration(
                                            color: Colors.green, // 버튼 색상
                                            borderRadius: BorderRadius.circular(
                                                30), // 둥근 모서리
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(
                                                    0, 3), // 그림자 위치
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            '문제 보러 사이트 가기',
                                            style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white, // 텍스트 색상
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          if (_bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
    );
  }
}

// Mapping of numbers to tier names and colors
const Map<int, String> probTierMapping = {
  0: 'Unrated',
  1: 'Bronze V',
  2: 'Bronze IV',
  3: 'Bronze III',
  4: 'Bronze II',
  5: 'Bronze I',
  6: 'Silver V',
  7: 'Silver IV',
  8: 'Silver III',
  9: 'Silver II',
  10: 'Silver I',
  11: 'Gold V',
  12: 'Gold IV',
  13: 'Gold III',
  14: 'Gold II',
  15: 'Gold I',
  16: 'Platinum V',
  17: 'Platinum IV',
  18: 'Platinum III',
  19: 'Platinum II',
  20: 'Platinum I',
  21: 'Diamond V',
  22: 'Diamond IV',
  23: 'Diamond III',
  24: 'Diamond II',
  25: 'Diamond I',
  26: 'Ruby V',
  27: 'Ruby IV',
  28: 'Ruby III',
  29: 'Ruby II',
  30: 'Ruby I',
};

const Map<int, Color> probTierColors = {
  0: Colors.grey, // Unrated
  1: Color(0xFFCD7F32), // Bronze V
  2: Color(0xFFCD7F32), // Bronze IV
  3: Color(0xFFCD7F32), // Bronze III
  4: Color(0xFFCD7F32), // Bronze II
  5: Color(0xFFCD7F32), // Bronze I
  6: Color.fromARGB(255, 220, 220, 220), // Silver V
  7: Color.fromARGB(255, 220, 220, 220), // Silver IV
  8: Color.fromARGB(255, 220, 220, 220), // Silver III
  9: Color.fromARGB(255, 220, 220, 220), // Silver II
  10: Color.fromARGB(255, 220, 220, 220), // Silver I
  11: Color(0xFFFFD700), // Gold V
  12: Color(0xFFFFD700), // Gold IV
  13: Color(0xFFFFD700), // Gold III
  14: Color(0xFFFFD700), // Gold II
  15: Color(0xFFFFD700), // Gold I
  16: Color(0xFF00C78A), // Platinum V
  17: Color(0xFF00C78A), // Platinum IV
  18: Color(0xFF00C78A), // Platinum III
  19: Color(0xFF00C78A), // Platinum II
  20: Color(0xFF00C78A), // Platinum I
  21: Color(0xFF00BFFF), // Diamond V
  22: Color(0xFF00BFFF), // Diamond IV
  23: Color(0xFF00BFFF), // Diamond III
  24: Color(0xFF00BFFF), // Diamond II
  25: Color(0xFF00BFFF), // Diamond I
  26: Color(0xFFE0115F), // Ruby V
  27: Color(0xFFE0115F), // Ruby IV
  28: Color(0xFFE0115F), // Ruby III
  29: Color(0xFFE0115F), // Ruby II
  30: Color(0xFFE0115F), // Ruby I
};
