import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solved_ac_browser/service/api_service.dart';
import 'package:solved_ac_browser/widget/end_drawer.dart';
import 'package:solved_ac_browser/widget/profile_stat.dart';
import 'package:solved_ac_browser/widget/top_protion.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Future<dynamic> user;
  late String currentHandle;
  late Timer _loadingTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    currentHandle = widget.userId;
    user = _fetchUserInfo();

    // 5초 동안 로딩이 지속되면 다이얼로그 호출
    _loadingTimer = Timer(const Duration(seconds: 5), () {
      if (_isLoading) {
        showHandleUpdateDialog();
      }
    });
  }

  @override
  void dispose() {
    _loadingTimer.cancel(); // 타이머 취소
    super.dispose();
  }

  Future<void> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // API에서 유저 정보를 가져오는 함수
  Future<dynamic> _fetchUserInfo() async {
    try {
      final userInfo = await SolvedacApi.getUserInfo(currentHandle);
      _isLoading = false;
      _loadingTimer.cancel(); // 성공 시 타이머 취소
      return userInfo;
    } catch (e) {
      _isLoading = false;
      _loadingTimer.cancel(); // 에러 시 타이머 취소
      // 에러 발생 시 자동으로 다이얼로그 호출
      Future.delayed(Duration.zero, () => showHandleUpdateDialog());
      return null;
    }
  }

  // Function to show AlertDialog for updating the handle
  void showHandleUpdateDialog() {
    final TextEditingController handleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "아이디를 잘못 입력하셨습니다. 다시 입력해 주세요.",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: TextField(
            controller: handleController,
            decoration: const InputDecoration(
              labelText: "여기에 입력",
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 업데이트 없이 창닫기
              },
              child: const Text(
                "닫기",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final newHandle = handleController.text.trim();
                if (newHandle.isNotEmpty) {
                  setState(() {
                    currentHandle = newHandle;
                    _isLoading = true;
                    user = _fetchUserInfo();
                    saveUserId(currentHandle); // SharedPreferences에 새로운 아이디 저장
                  });
                }
                Navigator.pop(context); // 업데이트 후 창닫기
              },
              child: const Text(
                "업데이트",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            // 잘못된 아이디 입력 시 다이얼로그 호출
            Future.delayed(Duration.zero, () => showHandleUpdateDialog());
            return const Center(
              child: Text('유저 정보를 불러오는데 실패했습니다.'),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: TopPortion(user: user), // 위쪽 프로필, 배경
                ),
                Expanded(
                  flex: 5,
                  child: ProfileInfo(
                    user: user,
                    onEditHandlePressed: showHandleUpdateDialog, // 콜백 전달
                  ),
                ),
              ],
            );
          }
        },
      ),
      endDrawer:
          EndDrawer(currentHandle: currentHandle, clearPrefs: clearPrefs),
    );
  }
}
