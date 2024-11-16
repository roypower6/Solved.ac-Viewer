import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/level_statistics_model.dart';
import 'package:solved_ac_browser/screen/statistics_screen/constants.dart';
import 'package:solved_ac_browser/screen/statistics_screen/stat_card.dart';
import 'package:solved_ac_browser/service/api_service.dart';
import 'package:solved_ac_browser/widget/problems_list.dart';

class LevelStatisticsScreen extends StatefulWidget {
  final String handle;
  const LevelStatisticsScreen({super.key, required this.handle});

  @override
  State<LevelStatisticsScreen> createState() => _LevelStatisticsScreenState();
}

class _LevelStatisticsScreenState extends State<LevelStatisticsScreen> {
  late Future<List<LevelStatisticsModel>> _levelStatisticsFuture;

  @override
  void initState() {
    super.initState();
    _levelStatisticsFuture = _fetchLevelStatistics();
  }

  Future<List<LevelStatisticsModel>> _fetchLevelStatistics() async {
    final levelStatistics =
        await SolvedacApi.getLevelStatisticsInfo(widget.handle);
    return levelStatistics.where((levelStat) => levelStat.solved > 0).toList();
  }

  Color _getColorForLevel(int level) {
    if (level <= 5) return AppColors.tierColors['bronze']!;
    if (level <= 10) return AppColors.tierColors['silver']!;
    if (level <= 15) return AppColors.tierColors['gold']!;
    if (level <= 20) return AppColors.tierColors['platinum']!;
    if (level <= 25) return AppColors.tierColors['diamond']!;
    return AppColors.tierColors['ruby']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('난이도별 문제풀이 통계', style: AppStyles.headerStyle),
      ),
      body: SafeArea(
        child: FutureBuilder<List<LevelStatisticsModel>>(
          future: _levelStatisticsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.hasError ? '통계를 불러오는데 실패했습니다.' : '통계 데이터가 없습니다.',
                      style: AppStyles.bodyStyle,
                    ),
                  ],
                ),
              );
            }

            final sortedStats = snapshot.data!
              ..sort((a, b) => b.solved.compareTo(a.solved));
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPieChartCard(sortedStats),
                const SizedBox(height: 5),
                _buildTierListCard(sortedStats),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPieChartCard(List<LevelStatisticsModel> stats) {
    return StatCard(
      title: '난이도별 분포',
      height: 420,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 70,
            sections: stats.map((stat) {
              final percentage = (stat.solved /
                      stats.fold(0, (sum, item) => sum + item.solved)) *
                  100;
              return PieChartSectionData(
                value: stat.solved.toDouble(),
                title:
                    percentage >= 5 ? '${percentage.toStringAsFixed(1)}%' : '',
                color: _getColorForLevel(stat.level),
                radius: 100,
                titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTierListCard(List<LevelStatisticsModel> stats) {
    return StatCard(
      height: 250,
      title: '티어별 해결 문제',
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: stats.map((stat) {
            final tierName = probTierMapping[stat.level] ?? 'Unknown';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _getColorForLevel(stat.level),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(tierName, style: AppStyles.bodyStyle),
                  ),
                  Text(
                    '${stat.solved} solved',
                    style: AppStyles.bodyStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
