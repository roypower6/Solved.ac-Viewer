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
    required this.onEditHandlePressed, // 콜백 수신
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // 높이를 약간 늘림
      constraints: const BoxConstraints(maxWidth: 400),
      child: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data as UserModel; // UserModel로 캐스팅
            final dynamic organization =
                SolvedacApi.getOrganizationInfo(user.handle);
            final dynamic problems = SolvedacApi.getProblemsInfo(user.handle);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.handle, // handle 값을 표시
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 27,
                              ),
                              overflow: TextOverflow.ellipsis, // 긴 텍스트 처리
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        indent: 20,
                        endIndent: 20,
                        color: Colors.black,
                      ),
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
                        indent: 20,
                        endIndent: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TierWidget(
                        tierNumber: user.tier,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: organization,
                        builder: (context2, snapshot2) {
                          if (snapshot2.hasData) {
                            final organizations =
                                snapshot2.data as List<OrganizationModel>;

                            return Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(
                                right: 18,
                                left: 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade500,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        '소속',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        organizations.first.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '레이팅: ${organizations.first.rating}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '인원 수: ${organizations.first.userCount}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Center(
                            child: Text(
                              "소속 기관이 없습니다.",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder(
                              future: coinrate,
                              builder: (context3, snapshot3) {
                                if (snapshot3.hasData) {
                                  final coinrate =
                                      snapshot3.data as CoinRateModel;
                                  return Tooltip(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    triggerMode: TooltipTriggerMode.tap,
                                    showDuration: const Duration(seconds: 4),
                                    message:
                                        '코인으로 환전했을 때 수수료 1%를 제하고 \n${((user.stardusts / coinrate.rate) * (99 / 100)).toStringAsFixed(2)}코인으로 바꿀 수 있습니다.',
                                    child: Expanded(
                                      flex: 0, // 보유 코인 수 박스가 더 넓게
                                      child: Container(
                                        width: 250,
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.only(
                                            right: 4, left: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                const Text(
                                                  '보유 코인 수',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  '${user.coins}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              children: [
                                                // 별가루 수
                                                const Text(
                                                  '보유 별가루 수',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  '${user.stardusts}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
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
                                  );
                                }
                                return const CircularProgressIndicator();
                              }),
                          // 두 번째 박스 - 최대 출력 일수
                          Expanded(
                            flex: 0, // 최대 스트릭 일수 박스가 더 작게
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(left: 4, right: 4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.shade200,
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${user.maxStreak}일',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ProblemsList(problems: problems),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

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
}
