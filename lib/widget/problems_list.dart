import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/problems_list_model.dart';

class ProblemsList extends StatelessWidget {
  final dynamic problems;
  const ProblemsList({
    super.key,
    required this.problems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FutureBuilder(
        future: problems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                '문제 목록을 불러오는데 실패했습니다.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final problemList = snapshot.data as List<ProblemsListModel>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.amber,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '해결한 문제 중 상위 100문제',
                    style: TextStyle(
                      color: Colors.grey.shade100,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '카드를 클릭해서 문제 정보를 확인해 보세요!',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: (problemList.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildProblemCard(
                              problemList[index * 2], index * 2, context),
                        ),
                        const SizedBox(width: 8),
                        if (index * 2 + 1 < problemList.length)
                          Expanded(
                            child: _buildProblemCard(problemList[index * 2 + 1],
                                index * 2 + 1, context),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProblemCard(
      ProblemsListModel problem, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showProblemDetails(context, problem),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: probTierColors[problem.level] ?? Colors.grey,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: probTierColors[problem.level]?.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: probTierColors[problem.level],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${problem.problemId}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      probTierMapping[problem.level] ?? 'Unknown',
                      style: TextStyle(
                        color: probTierColors[problem.level],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.military_tech_rounded,
                color: probTierColors[problem.level],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProblemDetails(BuildContext context, ProblemsListModel problem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          // 문제 이름
          problem.titleko,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.military_tech_rounded,
                  color: probTierColors[problem.level],
                  size: 25,
                ),
                const SizedBox(width: 8),
                Text(
                  // 문제 난이도
                  probTierMapping[problem.level] ?? 'Unknown',
                  style: TextStyle(color: Colors.grey.shade300),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              // 문제 번호
              '문제 번호: ${problem.problemId}',
              style: TextStyle(color: Colors.grey.shade300),
            ),
            const SizedBox(height: 8),
            Text(
              "문제 푼 사람: ${problem.acceptedUserCount}명",
              style: TextStyle(color: Colors.grey.shade300),
            ),
            const SizedBox(height: 8),
            Text(
              "평균 시도 횟수: ${problem.averageTries.toStringAsFixed(1)}회",
              style: TextStyle(color: Colors.grey.shade300),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '닫기',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

// Mapping of numbers to tier names
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
