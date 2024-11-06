import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/coin_rate_model.dart';
import 'package:solved_ac_browser/model/organization_model.dart';
import 'package:solved_ac_browser/model/user_model.dart';
import 'package:solved_ac_browser/service/api_service.dart';
import 'package:solved_ac_browser/widget/problems_list.dart';
import 'package:solved_ac_browser/widget/solve_tier_widget.dart';

class ProfileInfo extends StatelessWidget {
  final Future<dynamic> user;
  final VoidCallback onEditHandlePressed;
  final Future<dynamic> coinrate = SolvedacApi.getCoinRate();

  ProfileInfo({
    super.key,
    required this.user,
    required this.onEditHandlePressed,
  });

  Widget singleItem(
      BuildContext context, dynamic userValue, String description) {
    return Column(
      children: [
        Text(
          '$userValue',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
        Text(
          description,
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      constraints: const BoxConstraints(maxWidth: 400),
      child: FutureBuilder(
        future: Future.wait([user, coinrate]),
        builder: (context, AsyncSnapshot<List<dynamic>> mainSnapshot) {
          if (!mainSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = mainSnapshot.data![0] as UserModel;
          final coinrateData = mainSnapshot.data![1] as CoinRateModel;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      user.handle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Divider(
                        indent: 20, endIndent: 20, color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: singleItem(
                              context, user.solvedCount, "Solved Count"),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          child: singleItem(context, user.rank, "Rank"),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          child: singleItem(context, user.rating, "Rating"),
                        ),
                      ],
                    ),
                    const Divider(
                        indent: 20, endIndent: 20, color: Colors.black),
                    const SizedBox(height: 5),
                    TierWidget(tierNumber: user.tier),
                    const SizedBox(height: 10),
                    FutureBuilder(
                      future: SolvedacApi.getOrganizationInfo(user.handle),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text(
                              "소속 기관이 없습니다.",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          );
                        }

                        final org =
                            (snapshot.data as List<OrganizationModel>).first;
                        return Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 4),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          message:
                              '소속 기관 유형: ${org.type}\n소속 기관 전체 난이도 기여 수: ${org.voteCount}\n소속 기관 전체 해결 문제 수: ${org.solvedCount}',
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      '소속',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      org.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '문제풀이 레이팅: ${org.rating}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '소속 인원 수: ${org.userCount}명',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 4),
                          message:
                              '코인으로 환전했을 때 수수료 1%를 제하고 \n${((user.stardusts / coinrateData.rate) * (99 / 100)).toStringAsFixed(2)}코인으로 바꿀 수 있습니다.',
                          child: Container(
                            width: 250,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      '보유 코인 수',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${user.coins}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    const Text(
                                      '보유 별가루 수',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${user.stardusts}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                '최대 스트릭',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${user.maxStreak}일',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ProblemsList(
                      problems: SolvedacApi.getProblemsInfo(user.handle),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
