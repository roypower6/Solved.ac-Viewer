import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:solved_ac_browser/model/tags_statistics_model.dart';
import 'package:solved_ac_browser/service/admob_service.dart';
import 'package:solved_ac_browser/service/api_service.dart';

class StatisticsScreen extends StatefulWidget {
  final String handle;

  const StatisticsScreen({super.key, required this.handle});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<List<TagStatisticsModel>> _tagStatisticsFuture;
  final Map<String, Color> _tagColors = {}; // 태그에 대한 색상을 저장할 맵
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    // API 호출하여 통계 데이터를 가져오는 함수
    _tagStatisticsFuture = _fetchTagStatistics();
    createBannerAd();
  }

  void createBannerAd() {
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

  // API에서 태그별 문제 풀이 통계 가져오기
  Future<List<TagStatisticsModel>> _fetchTagStatistics() async {
    final tagsStatistics = await SolvedacApi.getTagsStaticsInfo(widget.handle);
    // solved가 0인 항목은 제외
    final filteredStats =
        tagsStatistics.where((tagStat) => tagStat.solved > 0).toList();

    // 태그별 랜덤 밝은 색상 생성
    for (var tagStat in filteredStats) {
      _tagColors[tagStat.key] = _getRandomBrightColor();
    }

    return filteredStats;
  }

  // 랜덤 밝은 색상 생성 함수
  Color _getRandomBrightColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256), //빨간색
      random.nextInt(256), //초록색
      random.nextInt(256), //파란색
    );
  }

  // PieChart 생성
  Widget _buildPieChart(List<TagStatisticsModel> tagStats) {
    // solved 값 기준으로 내림차순 정렬
    tagStats.sort((a, b) => b.solved.compareTo(a.solved));

    final totalSolved = tagStats.fold<int>(0, (sum, item) => sum + item.solved);

    return PieChart(
      PieChartData(
        centerSpaceRadius: 50,
        sections: tagStats.map((tagStat) {
          final double percentage = (tagStat.solved / totalSolved) * 100;
          // displayNames에서 한국어 이름을 우선적으로 가져오고, 없으면 기본 이름 사용
          final displayName = tagStat.displayName;

          return PieChartSectionData(
            title: percentage >= 10
                ? "$displayName\n${tagStat.solved} 문제"
                : '', // 10% 이상만 타이틀 표시
            value: tagStat.solved.toDouble(),
            color: _tagColors[tagStat.key], // 랜덤으로 생성된 색상 사용
            titleStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            showTitle: percentage >= 10, // 10% 이상만 타이틀 표시
            titlePositionPercentageOffset:
                percentage >= 10 ? 2.0 : 0, // 라벨을 바깥으로 이동
          );
        }).toList(),
      ),
    );
  }

  // 태그별 요소 리스트 생성
  Widget _buildTagList(List<TagStatisticsModel> tagStats) {
    return Expanded(
      child: ListView.builder(
        itemCount: tagStats.length,
        itemBuilder: (context, index) {
          final tagStat = tagStats[index];

          return ListTile(
            leading: Container(
              width: 16,
              height: 16,
              color: _tagColors[tagStat.key], // 랜덤 색상 적용
            ),
            title: Text(
              tagStat.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '${tagStat.solved} solved',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("태그별 문제풀이 통계"),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<TagStatisticsModel>>(
            future: _tagStatisticsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('통계를 불러오는데 실패했습니다.'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('통계 데이터가 없습니다.'));
              } else {
                // 통계 데이터를 이용해 파이차트와 리스트를 표시
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 1,
                        child: _buildPieChart(snapshot.data!),
                      ),
                      const SizedBox(height: 20),
                      _buildTagList(snapshot.data!), // 태그별 요소 리스트
                    ],
                  ),
                );
              }
            },
          ),
          if (_bannerAd != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StatefulBuilder(builder: (context, setState) {
                return SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                );
              }),
            ),
        ],
      ),
    );
  }
}
