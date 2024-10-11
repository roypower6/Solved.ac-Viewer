import 'package:flutter/material.dart';

class TierWidget extends StatelessWidget {
  final int tierNumber;

  // Mapping of numbers to tier names
  final Map<int, String> tierMapping = {
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

  // Mapping of numbers to border colors based on tier
  final Map<int, Color> tierColorMapping = {
    0: Colors.grey, //Unrated
    1: Colors.brown.shade700, // Bronze
    2: Colors.brown.shade700,
    3: Colors.brown.shade700,
    4: Colors.brown.shade700,
    5: Colors.brown.shade700,
    6: Colors.grey.shade300, // Silver
    7: Colors.grey.shade300,
    8: Colors.grey.shade300,
    9: Colors.grey.shade300,
    10: Colors.grey.shade300,
    11: Colors.amber.shade700, // Gold
    12: Colors.amber.shade700,
    13: Colors.amber.shade700,
    14: Colors.amber.shade700,
    15: Colors.amber.shade700,
    16: const Color.fromARGB(255, 50, 170, 120), // Platinum
    17: const Color.fromARGB(255, 50, 170, 120),
    18: const Color.fromARGB(255, 50, 170, 120),
    19: const Color.fromARGB(255, 50, 170, 120),
    20: const Color.fromARGB(255, 50, 170, 120),
    21: Colors.blue.shade700, // Diamond
    22: Colors.blue.shade700,
    23: Colors.blue.shade700,
    24: Colors.blue.shade700,
    25: Colors.blue.shade700,
    26: Colors.red.shade700, // Ruby
    27: Colors.red.shade700,
    28: Colors.red.shade700,
    29: Colors.red.shade700,
    30: Colors.red.shade700,
    31: Colors.purple.shade700, // Master
  };

  TierWidget({super.key, required this.tierNumber});

  @override
  Widget build(BuildContext context) {
    // Fetch the tier name using the tierNumber
    String tierName = tierMapping[tierNumber] ?? 'Unknown';
    Color borderColor = tierColorMapping[tierNumber] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(
        right: 18,
        left: 18,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: borderColor, // Set background to white or any other color
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
          const Text(
            "Solve 티어",
            style: TextStyle(
              color: Colors.white, // Text color set to black
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            ":",
            style: TextStyle(
              color: Colors.white, // Text color set to black
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            tierName,
            style: const TextStyle(
              color: Colors.white, // Text color set to black
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
