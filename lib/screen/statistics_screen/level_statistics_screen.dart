import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:solved_ac_browser/model/level_statistics_model.dart';
import 'package:solved_ac_browser/service/admob_service.dart';
import 'package:solved_ac_browser/service/api_service.dart';

class LevelStatisticsScreen extends StatefulWidget {
  final String handle;

  const LevelStatisticsScreen({super.key, required this.handle});

  @override
  State<LevelStatisticsScreen> createState() => _LevelStatisticsScreenState();
}

class _LevelStatisticsScreenState extends State<LevelStatisticsScreen> {
  late Future<List<LevelStatisticsModel>> _levelStatisticsFuture;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _levelStatisticsFuture = _fetchLevelStatistics();
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

  Future<List<LevelStatisticsModel>> _fetchLevelStatistics() async {
    final levelStatistics =
        await SolvedacApi.getLevelStatisticsInfo(widget.handle);
    return levelStatistics.where((levelStat) => levelStat.solved > 0).toList();
  }

  Color _getColorForLevel(int level) {
    final colorMapping = {
      0: Colors.brown.shade500,
      1: Colors.grey,
      2: Colors.amber.shade700,
      3: const Color.fromARGB(255, 50, 170, 120),
      4: Colors.blue.shade700,
      5: Colors.red.shade700
    };
    return colorMapping[level ~/ 5] ?? Colors.transparent;
  }

  Widget _buildPieChart(List<LevelStatisticsModel> levelStats) {
    int totalSolved = levelStats.fold(0, (sum, item) => sum + item.solved);
    return PieChart(
      PieChartData(
        sections: levelStats.map((levelStat) {
          double percentage = (levelStat.solved / totalSolved) * 100;
          String tierName = levelTiers[levelStat.level] ?? 'Unknown Tier';
          return PieChartSectionData(
            value: levelStat.solved.toDouble(),
            title: percentage < 10 ? '' : "$tierName\n${levelStat.solved} 문제",
            color: _getColorForLevel(levelStat.level),
            radius: 50,
            titleStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
            titlePositionPercentageOffset: percentage >= 10 ? 1.8 : 0,
          );
        }).toList(),
        centerSpaceRadius: 50,
      ),
    );
  }

  Widget _buildLevelList(List<LevelStatisticsModel> levelStats) {
    return Expanded(
      child: ListView.builder(
        itemCount: levelStats.length,
        itemBuilder: (context, index) {
          final levelStat = levelStats[index];
          final tierName = levelTiers[levelStat.level] ?? 'Unknown Tier';
          return ListTile(
            title: Text(tierName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text('${levelStat.solved} solved',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("난이도별 문제풀이 통계")),
      body: Stack(
        children: [
          FutureBuilder<List<LevelStatisticsModel>>(
            future: _levelStatisticsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('통계를 불러오는데 실패했습니다.'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('통계 데이터가 없습니다.'));
              } else {
                List<LevelStatisticsModel> sortedStatistics = snapshot.data!
                  ..sort((a, b) => b.solved.compareTo(a.solved));
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                          flex: 1, child: _buildPieChart(sortedStatistics)),
                      const SizedBox(height: 20),
                      _buildLevelList(sortedStatistics),
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

final Map<int, String> levelTiers = {
  0: "Unrated / Not Ratable",
  1: "Bronze V",
  2: "Bronze IV",
  3: "Bronze III",
  4: "Bronze II",
  5: "Bronze I",
  6: "Silver V",
  7: "Silver IV",
  8: "Silver III",
  9: "Silver II",
  10: "Silver I",
  11: "Gold V",
  12: "Gold IV",
  13: "Gold III",
  14: "Gold II",
  15: "Gold I",
  16: "Platinum V",
  17: "Platinum IV",
  18: "Platinum III",
  19: "Platinum II",
  20: "Platinum I",
  21: "Diamond V",
  22: "Diamond IV",
  23: "Diamond III",
  24: "Diamond II",
  25: "Diamond I",
  26: "Ruby V",
  27: "Ruby IV",
  28: "Ruby III",
  29: "Ruby II",
  30: "Ruby I",
};
