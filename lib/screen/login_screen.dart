import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solved_ac_browser/screen/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController controller = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadSavedId(); // 앱 시작 시 저장된 ID 불러오기
  }

  // SharedPreferences에서 저장된 ID를 불러오기
  void loadSavedId() async {
    prefs = await SharedPreferences.getInstance();
    String? savedId = prefs.getString('userId');
    if (savedId != null && savedId.isNotEmpty) {
      // 저장된 ID가 있다면 바로 ProfileScreen으로 이동
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userId: savedId),
        ),
      );
    }
  }

  // ID 저장하기
  void saveIdAndProceed() {
    String userId = controller.text;
    if (userId.isNotEmpty) {
      prefs.setString('userId', userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userId: userId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset(
                'assets/images/ic_launcher.png',
                scale: 0.8,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Solved.ac 아이디를 입력해주세요!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                icon: Icon(Icons.perm_identity_sharp),
                labelText: 'Solved.ac ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: saveIdAndProceed,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.green, // 버튼 색상
                  borderRadius: BorderRadius.circular(30), // 둥근 모서리
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // 그림자 위치
                    ),
                  ],
                ),
                child: const Text(
                  '저장',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // 텍스트 색상
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
