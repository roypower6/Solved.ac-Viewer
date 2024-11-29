import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:solved_ac_browser/model/statistics_model/tags_statistics_model.dart';
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

    _tagColors.clear();

    for (var tagStat in filteredStats) {
      _tagColors[tagStat.key] = _getRandomPastelColor();
    }

    return filteredStats;
  }

  Color _getRandomPastelColor() {
    final Random random = Random();

    final hue = random.nextDouble() * 360;
    final saturation = 35 + random.nextDouble() * 30;
    final lightness = 65 + random.nextDouble() * 20;

    final hslColor =
        HSLColor.fromAHSL(1, hue, saturation / 100, lightness / 100);
    return hslColor.toColor();
  }

  Widget _buildPieChart(List<TagStatisticsModel> tagStats) {
    final totalSolved = tagStats.fold(0, (sum, tag) => sum + tag.solved);

    return StatCard(
      title: '태그별 문제 비율',
      height: 450,
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 1,
                centerSpaceRadius: 30,
                sections: tagStats.map((tag) {
                  final percentage = (tag.solved / totalSolved * 100);
                  return PieChartSectionData(
                    value: tag.solved.toDouble(),
                    title: percentage >= 3
                        ? '${percentage.toStringAsFixed(1)}%'
                        : '',
                    titleStyle: AppStyles.bodyStyle.copyWith(
                      fontSize: 11,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                    color: _tagColors[tag.key],
                    radius: 120,
                    showTitle: true,
                  );
                }).toList(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 150),
            ),
          ),
          // 상위 5개 태그에 대한 범례 추가
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: tagStats.take(5).map((tag) {
                final percentage = (tag.solved / totalSolved * 100);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _tagColors[tag.key],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${tag.displayName} (${percentage.toStringAsFixed(1)}%)',
                      style: AppStyles.bodyStyle.copyWith(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
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

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPieChart(sortedStats),
                    const SizedBox(height: 16),
                    _buildTagList(sortedStats),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
