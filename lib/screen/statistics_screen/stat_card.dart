import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:solved_ac_browser/screen/statistics_screen/constants.dart';

class StatCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double height;

  const StatCard({
    super.key,
    required this.title,
    required this.child,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: AppStyles.subheaderStyle),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
