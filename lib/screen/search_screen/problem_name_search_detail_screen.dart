import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/problem_num_search_model.dart';
import 'package:solved_ac_browser/widget/solve_tier_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProblemNameSearchDetailScreen extends StatefulWidget {
  final ProblemModel problem;

  const ProblemNameSearchDetailScreen({super.key, required this.problem});

  @override
  State<ProblemNameSearchDetailScreen> createState() =>
      _ProblemNameSearchDetailScreenState();
}

class _ProblemNameSearchDetailScreenState
    extends State<ProblemNameSearchDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.problem.titleKo),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            TierWidget(tierNumber: widget.problem.level),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '문제 정보',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InfoRow(label: '문제 번호', value: '${widget.problem.problemId}'),
                  InfoRow(
                    label: '평균 시도 횟수',
                    value: '${widget.problem.averageTries.toStringAsFixed(1)}회',
                  ),
                  InfoRow(
                    label: '해결한 사용자',
                    value: '${widget.problem.acceptedUserCount}명',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '문제 태그',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.problem.tags.map((tag) {
                      final displayName = tag.displayNames
                          .firstWhere((name) => name.language == 'ko')
                          .name;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          displayName,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  buildProblemLinkButton(widget.problem.problemId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProblemLinkButton(int problemId) {
    return Center(
      child: GestureDetector(
        onTap: () {
          final url = 'https://www.acmicpc.net/problem/$problemId';
          launchUrl(Uri.parse(url));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Text(
            '문제 보러 사이트 가기',
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
