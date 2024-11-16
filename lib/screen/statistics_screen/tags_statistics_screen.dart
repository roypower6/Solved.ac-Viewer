import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:solved_ac_browser/model/tags_statistics_model.dart';
import 'package:solved_ac_browser/service/api_service.dart';
import 'package:solved_ac_browser/screen/statistics_screen/stat_card.dart';
import 'package:solved_ac_browser/screen/statistics_screen/constants.dart';

class StatisticsScreen extends StatefulWidget {
  final String handle;

  const StatisticsScreen({super.key, required this.handle});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<List<TagStatisticsModel>> _tagStatisticsFuture;
  final Map<String, Color> _tagColors = {};

  @override
  void initState() {
    super.initState();
    _tagStatisticsFuture = _fetchTagStatistics();
  }

  Future<List<TagStatisticsModel>> _fetchTagStatistics() async {
    final tagsStatistics = await SolvedacApi.getTagsStaticsInfo(widget.handle);
    final filteredStats =
        tagsStatistics.where((tagStat) => tagStat.solved > 0).toList();

    for (var tagStat in filteredStats) {
      _tagColors[tagStat.key] = _getRandomBrightColor();
    }

    return filteredStats;
  }

  Color _getRandomBrightColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Widget _buildPieChart(List<TagStatisticsModel> tagStats) {
    tagStats.sort((a, b) => b.solved.compareTo(a.solved));
    final totalSolved = tagStats.fold<int>(0, (sum, item) => sum + item.solved);

    return StatCard(
      title: '태그별 분포',
      height: 420,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 70,
            sections: tagStats.map((tagStat) {
              final percentage = (tagStat.solved / totalSolved) * 100;
              return PieChartSectionData(
                value: tagStat.solved.toDouble(),
                title:
                    percentage >= 5 ? '${percentage.toStringAsFixed(1)}%' : '',
                color: _tagColors[tagStat.key]!,
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

  Widget _buildTagList(List<TagStatisticsModel> tagStats) {
    return StatCard(
      title: '태그별 해결 문제',
      height: 250,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: tagStats.map((tagStat) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _tagColors[tagStat.key],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      tagStat.displayName,
                      style: AppStyles.bodyStyle,
                    ),
                  ),
                  Text(
                    '${tagStat.solved} solved',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('태그별 문제풀이 통계', style: AppStyles.headerStyle),
      ),
      body: SafeArea(
        child: FutureBuilder<List<TagStatisticsModel>>(
          future: _tagStatisticsFuture,
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
                _buildPieChart(sortedStats),
                const SizedBox(height: 5),
                _buildTagList(sortedStats),
              ],
            );
          },
        ),
      ),
    );
  }
}
