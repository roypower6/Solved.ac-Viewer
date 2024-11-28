import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/statistics_model/class_statistics_model.dart';
import 'package:solved_ac_browser/screen/statistics_screen/constants.dart';
import 'package:solved_ac_browser/screen/statistics_screen/stat_card.dart';
import 'package:solved_ac_browser/service/api_service.dart';

class ClassStatisticsScreen extends StatefulWidget {
  final String handle;
  const ClassStatisticsScreen({super.key, required this.handle});

  @override
  ClassStatisticsScreenState createState() => ClassStatisticsScreenState();
}

class ClassStatisticsScreenState extends State<ClassStatisticsScreen> {
  late Future<List<ClassStatisticsModel>> _classStatisticsFuture;

  @override
  void initState() {
    super.initState();
    _classStatisticsFuture = SolvedacApi.getClassStatisticsInfo(widget.handle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "클래스별 문제풀이 통계",
          style: AppStyles.headerStyle,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<ClassStatisticsModel>>(
          future: _classStatisticsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      '통계를 불러오는데 실패했습니다.',
                      style: AppStyles.bodyStyle,
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('통계 데이터가 없습니다.', style: AppStyles.bodyStyle),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProgressSummary(snapshot.data!),
                const SizedBox(height: 16),
                _buildClassList(snapshot.data!),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressSummary(List<ClassStatisticsModel> stats) {
    final totalProblems = stats.fold<int>(
      0,
      (sum, stat) => sum + stat.totalSolved,
    );
    final totalEssentials = stats.fold<int>(
      0,
      (sum, stat) => sum + stat.essentialSolved,
    );

    return StatCard(
      title: '진행 중인 클래스 전체 현황',
      height: 180,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildSummaryItem(
              '총 문제 수',
              totalProblems.toString(),
              Icons.assignment,
            ),
            const SizedBox(width: 24),
            _buildSummaryItem(
              '해결한 에센셜',
              totalEssentials.toString(),
              Icons.star,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(value, style: AppStyles.subheaderStyle),
          const SizedBox(height: 4),
          Text(label, style: AppStyles.bodyStyle),
        ],
      ),
    );
  }

  Widget _buildClassList(List<ClassStatisticsModel> classStats) {
    return StatCard(
      title: '클래스별 진행도',
      height: 500,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: classStats.length,
        itemBuilder: (context, index) {
          final classStat = classStats[index];
          if (classStat.essentialSolved == 0) return const SizedBox.shrink();

          final progress = classStat.essentialSolved / classStat.essentials;
          final isCompleted = classStat.essentialSolved == classStat.essentials;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Class ${classStat.classes}',
                      style: AppStyles.subheaderStyle,
                    ),
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: isCompleted
                            ? Colors.green
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(
                      isCompleted ? Colors.green : AppColors.primary,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '에센셜: ${classStat.essentialSolved}/${classStat.essentials}  •  총 문제: ${classStat.totalSolved}',
                  style: AppStyles.bodyStyle,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
