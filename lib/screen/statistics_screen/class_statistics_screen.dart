import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/class_statistics_model.dart';
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
      appBar: AppBar(
        title: const Text("클래스별 문제풀이 통계"),
      ),
      body: Expanded(
        child: FutureBuilder<List<ClassStatisticsModel>>(
          future: _classStatisticsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('통계를 불러오는데 실패했습니다.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('통계 데이터가 없습니다.'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Expanded(
                      flex: 1,
                      child: _buildClassList(snapshot.data!),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildClassList(List<ClassStatisticsModel> classStats) {
    return ListView.builder(
      itemCount: classStats.length,
      itemBuilder: (context, index) {
        final classStat = classStats[index];
        return ClassStatWidget(classStat: classStat);
      },
    );
  }
}

class ClassStatWidget extends StatelessWidget {
  final ClassStatisticsModel classStat;

  const ClassStatWidget({super.key, required this.classStat});

  @override
  Widget build(BuildContext context) {
    // Essential Solved가 0일 경우 타일을 숨김
    if (classStat.essentialSolved == 0) {
      return const SizedBox.shrink(); // 빈 위젯을 반환해 타일이 나타나지 않음
    }

    // Essential Solved와 Essentials가 같으면 다른 색상 적용
    final bool isEssentialCompleted =
        classStat.essentialSolved == classStat.essentials;

    // Essential Solved 퍼센트 계산
    final double essentialSolvedPercentage = classStat.essentials > 0
        ? (classStat.essentialSolved / classStat.essentials) * 100
        : 0;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 5,
          top: 5,
        ),
        title: Text(
          'Class ${classStat.classes}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '푼 문제 수: ${classStat.totalSolved}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '해결한 에센셜 문제 수: ${classStat.essentialSolved}/${classStat.essentials}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isEssentialCompleted ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
        // 진행도를 trailing에 %로 표시
        trailing: Text(
          '${essentialSolvedPercentage.toStringAsFixed(1)}%', // 퍼센트로 표시
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isEssentialCompleted ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }
}
