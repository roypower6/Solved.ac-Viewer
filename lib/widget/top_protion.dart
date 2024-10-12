import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/background_model.dart';
import 'package:solved_ac_browser/model/badge_model.dart';
import 'package:solved_ac_browser/model/user_model.dart';
import 'package:solved_ac_browser/service/api_service.dart';

class TopPortion extends StatelessWidget {
  final Future<dynamic> user;

  const TopPortion({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data as UserModel;

            final Future<dynamic> background =
                SolvedacApi.getbackgroundInfo(user.backgroundId);
            return FutureBuilder(
                future: background,
                builder: (context2, snapshot2) {
                  if (snapshot2.hasData) {
                    final background = snapshot2.data as BackgroundModel;

                    final Future<dynamic> badge =
                        SolvedacApi.getBadgeInfo(user.badgeId); // 뱃지 정보

                    return FutureBuilder(
                      future: badge,
                      builder: (context3, snapshot3) {
                        if (snapshot3.hasData) {
                          final badgeData = snapshot3.data as BadgeModel;

                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 50),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        background.backgroundImageUrl),
                                  ),
                                  gradient: const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xff0043ba),
                                        Color(0xff006df1)
                                      ]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 6,
                                                spreadRadius: 2,
                                                offset: const Offset(3, 4),
                                              )
                                            ],
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  user.profileImageUrl),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Tooltip(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            showDuration:
                                                const Duration(seconds: 4),
                                            triggerMode: TooltipTriggerMode.tap,
                                            message:
                                                "뱃지 이름: ${badgeData.displayName}\n설명: ${badgeData.displayDescription}",
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      badgeData.badgeImageUrl),
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
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  right: 5,
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Scaffold.of(context).openEndDrawer();
                                        },
                                        icon: const Icon(
                                          Icons.list,
                                          size: 45,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Dialog 띄우기
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('앱 도움말'),
                                                content: const Text(
                                                  '왼쪽 위의 리스트 아이콘을 누르면 다양한 통계와 코인샵에서 살 수 있는 아이템, 백준 문제 등을 볼 수 있습니다!\n\n보유 코인 수와 별가루 수가 있는 박스를 누르면 현재 교환 가능한 코인 수를 알 수 있습니다.\n\n하단의 검은색 박스 안에는 유저님이 푸신 문제 중 상위 100문제가 리스트로 정렬되어 있습니다.한 번 눌러서 문제 이름과 난이도를 확인해 보세요!\n',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Dialog 닫기
                                                    },
                                                    child: const Text('닫기'),
                                                  ),
                                                ],
                                              );
                                            },
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
                              ),
                            ],
                          );
                        }
                        return Container(
                          color: Colors.transparent,
                        );
                      },
                    );
                  }
                  return Container(
                    color: Colors.transparent,
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
