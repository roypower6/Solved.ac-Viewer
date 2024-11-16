import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2196F3);
  static const secondary = Color(0xFF64B5F6);
  static const background = Color(0xFFF5F5F5);
  static const cardBg = Colors.white;
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);

  static const tierColors = {
    'bronze': Color(0xFFAD5600),
    'silver': Color(0xFF435F7A),
    'gold': Color(0xFFEC9A00),
    'platinum': Color(0xFF27E2A4),
    'diamond': Color(0xFF00B4FC),
    'ruby': Color(0xFFFF0062),
  };
}

class AppStyles {
  static const cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  static const cardDecoration = BoxDecoration(
    color: AppColors.cardBg,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  static const headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const subheaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const bodyStyle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );
}
