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
    return Expanded(
      flex: 4,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
                child: Text('문제 목록을 불러오는데 실패했습니다.'),
              );
            } else {
              final problemList = snapshot.data as List<ProblemsModel>;

              return GridView.builder(
                padding: const EdgeInsets.all(0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8, // 한 줄에 8개씩 배치
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 1, // 정사각형 형태로 맞춤
                ),
                itemCount: problemList.length,
                itemBuilder: (context, index) {
                  final problem = problemList[index];
                  return Tooltip(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    triggerMode: TooltipTriggerMode.tap,
                    message:
                        '${problem.titleko} \n백준 문제번호: ${problem.problemId}\n문제 티어: ${probTierMapping[problem.level]}',
                    showDuration: const Duration(seconds: 4),
                    child: Icon(
                      Icons.book_rounded,
                      color: probTierColors[problem.level] ?? Colors.grey,
                      size: 40,
                    ),
                  );
                },
              );
            }
          },
        ),
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
