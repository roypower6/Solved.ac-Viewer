import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/background_model.dart';
import 'package:solved_ac_browser/model/badge_model.dart';
import 'package:solved_ac_browser/model/user_model.dart';
import 'package:solved_ac_browser/service/api_service.dart';

class TopPortion extends StatelessWidget {
  final Future<dynamic> user;

  static const double _profileSize = 115.0;
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
    if (snapshot.hasError) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.grey[900],
            ),
            child: Center(
              child: Text(
                '데이터를 불러오는데 실패했습니다.\n${snapshot.error}',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = snapshot.data as UserModel;

    return FutureBuilder(
      future: Future.wait([
        SolvedacApi.getbackgroundInfo(user.backgroundId),
        SolvedacApi.getBadgeInfo(user.badgeId),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasError) {
          // 프로필 정보 불러오기 실패 시
          return Center(
            child: Text(
              '프로필 정보를 불러오는데 실패했습니다.\n${snapshot.error}',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          );
        }
        return _buildUserProfile(context, snapshot, user);
      },
    );
  }

  Widget _buildUserProfile(BuildContext context,
      AsyncSnapshot<List<dynamic>> snapshot, UserModel user) {
    if (!snapshot.hasData || snapshot.data == null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.grey[900],
            ),
            child: const Center(
              child: Text(
                '배경 및 뱃지 정보를 불러올 수 없습니다.',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    final background = snapshot.data![0] as BackgroundModel?;
    final badgeData = snapshot.data![1] as BadgeModel?;

    if (background == null || badgeData == null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.grey[900],
            ),
            child: const Center(
              child: Text(
                '프로필 데이터가 올바르지 않습니다.',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(context, background),
        _buildBackgroundInfoButton(context, background),
        _buildActionButtons(context, user, badgeData),
      ],
    );
  }

  Widget _buildBackground(BuildContext context, BackgroundModel background) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(background.backgroundImageUrl),
        ),
        color: Colors.grey[900],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundInfoButton(
      BuildContext context, BackgroundModel background) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    '배경 정보',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '배경 이름: ${background.displayName}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '배경 설명: ${background.displayDescription}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '획득 조건: ${background.conditions}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        '닫기',
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.photo_size_select_actual_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context,
      [UserModel? user, BadgeModel? badgeData]) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 15),
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.grey[900],
                      title: const Text(
                        '앱 도움말',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        '왼쪽 위의 리스트 아이콘을 누르면 다양한 통계와 코인샵에서 살 수 있는 아이템, 백준 문제 등을 볼 수 있습니다!\n\n보유 코인 수와 별가루 수가 있는 박스를 누르면 가지고 있는 별가루를 통해 현재 교환 가능한 코인 수를 알 수 있습니다.\n\n하단의 검은색 박스 안에는 유저님이 푸신 문제 중 상위 100문제가 리스트로 정렬되어 있습니다.한 번 눌러서 문제 이름과 난이도, 문제 번호들을 확인해 보세요!\n',
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            '닫기',
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.info_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (user != null && badgeData != null) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.grey[900],
                        title: const Text(
                          '프로필 정보',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: _profileSize,
                              height: _profileSize,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(user.profileImageUrl),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: _badgeSize,
                              height: _badgeSize,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(badgeData.badgeImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "뱃지 이름: ${badgeData.displayName}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "설명: ${badgeData.displayDescription}",
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              '닫기',
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.account_circle,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(
                  Icons.list,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
