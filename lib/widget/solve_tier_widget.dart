import 'package:flutter/material.dart';

// Constants moved outside of the class
const Map<int, String> kTierMapping = {
  0: 'Unrated',
  1: 'Bronze V',
  2: 'Bronze IV',
  3: 'Bronze III',
  4: 'Bronze II',
  5: 'Bronze I',
  6: 'Silver V',
  7: 'Silver IV',
  8: 'Silver III',
  9: 'Silver II',
  10: 'Silver I',
  11: 'Gold V',
  12: 'Gold IV',
  13: 'Gold III',
  14: 'Gold II',
  15: 'Gold I',
  16: 'Platinum V',
  17: 'Platinum IV',
  18: 'Platinum III',
  19: 'Platinum II',
  20: 'Platinum I',
  21: 'Diamond V',
  22: 'Diamond IV',
  23: 'Diamond III',
  24: 'Diamond II',
  25: 'Diamond I',
  26: 'Ruby V',
  27: 'Ruby IV',
  28: 'Ruby III',
  29: 'Ruby II',
  30: 'Ruby I',
  31: 'Master'
};

class TierColors {
  static const Color platinum = Color.fromARGB(255, 50, 170, 120);

  static final Map<int, Color> tierColors = {
    0: Colors.grey, // Unrated
    ...List.generate(5, (i) => i + 1)
        .fold({}, (map, i) => {...map, i: Colors.brown.shade700}), // Bronze
    ...List.generate(5, (i) => i + 6)
        .fold({}, (map, i) => {...map, i: Colors.grey.shade300}), // Silver
    ...List.generate(5, (i) => i + 11)
        .fold({}, (map, i) => {...map, i: Colors.amber.shade700}), // Gold
    ...List.generate(5, (i) => i + 16)
        .fold({}, (map, i) => {...map, i: platinum}), // Platinum
    ...List.generate(5, (i) => i + 21)
        .fold({}, (map, i) => {...map, i: Colors.blue.shade700}), // Diamond
    ...List.generate(5, (i) => i + 26)
        .fold({}, (map, i) => {...map, i: Colors.red.shade700}), // Ruby
    31: Colors.purple.shade700, // Master
  };
}

class TierWidget extends StatelessWidget {
  final int tierNumber;

  // EdgeInsets constant
  static const EdgeInsets _containerMargin =
      EdgeInsets.symmetric(horizontal: 18);
  static const EdgeInsets _containerPadding = EdgeInsets.all(10);
  static const double _borderRadius = 15;

  const TierWidget({
    super.key,
    required this.tierNumber,
  });

  @override
  Widget build(BuildContext context) {
    final String tierName = kTierMapping[tierNumber] ?? 'Unknown';
    final Color borderColor = TierColors.tierColors[tierNumber] ?? Colors.grey;

    return Container(
      padding: _containerPadding,
      margin: _containerMargin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: Colors.white,
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
          _buildTierText("Solve 티어", Colors.black, 24),
          _buildTierText(":", Colors.black, 24),
          _buildTierText(tierName, borderColor, 27),
        ],
      ),
    );
  }

  Widget _buildTierText(String text, Color color, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
