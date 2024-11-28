import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/background_model.dart';
import 'package:solved_ac_browser/model/badge_model.dart';
import 'package:solved_ac_browser/model/user_model.dart';
import 'package:solved_ac_browser/service/api_service.dart';

class TopPortion extends StatelessWidget {
  final Future<dynamic> user;

  static const double _profileSize = 120.0;
  static const double _badgeSize = 40.0;

  const TopPortion({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: user,
        builder: _buildUserContent,
      ),
    );
  }

  Widget _buildUserContent(
      BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = snapshot.data as UserModel;
    return FutureBuilder(
      future: Future.wait([
        SolvedacApi.getbackgroundInfo(user.backgroundId),
        SolvedacApi.getBadgeInfo(user.badgeId),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) =>
          _buildUserProfile(context, snapshot, user),
    );
  }

  Widget _buildUserProfile(BuildContext context,
      AsyncSnapshot<List<dynamic>> snapshot, UserModel user) {
    if (!snapshot.hasData) {
      return Container(color: Colors.transparent);
    }

    final background = snapshot.data![0] as BackgroundModel;
    final badgeData = snapshot.data![1] as BadgeModel;

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(background),
        _buildBackgroundInfoButton(background),
        _buildProfileImage(user, badgeData),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildBackground(BackgroundModel background) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(background.backgroundImageUrl),
        ),
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xff0043ba), Color(0xff006df1)],
        ),
      ),
    );
  }

  Widget _buildBackgroundInfoButton(BackgroundModel background) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15),
      child: Align(
        alignment: Alignment.topLeft,
        child: Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 10),
          message:
              "배경 이름: ${background.displayName}\n배경 설명: ${background.displayDescription}\n획득 조건: ${background.conditions}",
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          child: const Icon(
            Icons.photo_size_select_actual_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(UserModel user, BadgeModel badgeData) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: SizedBox(
          width: _profileSize,
          height: _profileSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(3, 4),
                    )
                  ],
                  color: Colors.black,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(user.profileImageUrl),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Tooltip(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  showDuration: const Duration(seconds: 4),
                  triggerMode: TooltipTriggerMode.tap,
                  message:
                      "뱃지 이름: ${badgeData.displayName}\n설명: ${badgeData.displayDescription}",
                  child: Container(
                    width: _badgeSize,
                    height: _badgeSize,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(badgeData.badgeImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 5),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.list, size: 45, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('앱 도움말'),
                    content: const Text(
                      '왼쪽 위의 리스트 아이콘을 누르면 다양한 통계와 코인샵에서 살 수 있는 아이템, 백준 문제 등을 볼 수 있습니다!\n\n보유 코인 수와 별가루 수가 있는 박스를 누르면 가지고 있는 별가루를 통해 현재 교환 가능한 코인 수를 알 수 있습니다.\n\n하단의 검은색 박스 안에는 유저님이 푸신 문제 중 상위 100문제가 리스트로 정렬되어 있습니다.한 번 눌러서 문제 이름과 난이도, 문제 번호들을 확인해 보세요!\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('닫기'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.info_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
