import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:solved_ac_browser/model/problem_num_search_model.dart';
import 'package:solved_ac_browser/widget/problems_list.dart';
import 'package:url_launcher/url_launcher.dart';

class ProblemNumSearchScreen extends StatefulWidget {
  const ProblemNumSearchScreen({super.key});

  @override
  ProblemNumSearchScreenState createState() => ProblemNumSearchScreenState();
}

class ProblemNumSearchScreenState extends State<ProblemNumSearchScreen> {
  final TextEditingController _problemIdController = TextEditingController();
  Future<ProblemModel?>? _problemFuture;
  bool _isLoading = false;

  Future<ProblemModel?> fetchProblem(int problemId) async {
    final url =
        Uri.parse('https://solved.ac/api/v3/problem/show?problemId=$problemId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return ProblemModel.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching problem: $error");
      }
    }
    return null;
  }

  Future<void> _onSearch(String value) async {
    final problemId = int.tryParse(value);
    if (problemId != null) {
      setState(() {
        _isLoading = true;
        _problemFuture = fetchProblem(problemId);
      });
      await _problemFuture;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("백준 문제번호 검색")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _problemIdController,
              decoration: InputDecoration(
                hintText: '문제 번호',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _onSearch(_problemIdController.text),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: _onSearch,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildResultView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    if (_problemFuture == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<ProblemModel?>(
      future: _problemFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(
            child: Text(
              "문제를 찾을 수 없습니다.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        final problem = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                problem.titleKo,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                '문제 ${problem.problemId}번',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    probTierMapping[problem.level] ?? 'Unknown',
                    style: TextStyle(
                      color: probTierColors[problem.level],
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    '${problem.acceptedUserCount}명 해결',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "평균 시도 횟수: ${problem.averageTries.toStringAsFixed(1)}회",
                style: TextStyle(color: Colors.grey[800], fontSize: 17),
              ),
              const SizedBox(height: 16),
              const Text("태그:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _buildTags(problem.tags),
              const SizedBox(height: 24),
              buildProblemLinkButton(problem.problemId),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTags(List<Tag> tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag.displayNames.first.name,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
        );
      }).toList(),
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
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
