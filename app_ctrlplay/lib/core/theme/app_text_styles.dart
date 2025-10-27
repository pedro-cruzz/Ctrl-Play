import 'package:flutter/material.dart';
import 'package:project/core/theme/app_colors.dart';

class AppTextStyles {
  static const heading = TextStyle(
    color: AppColors.textLight,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const title = TextStyle(
    color: AppColors.primary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    color: AppColors.primary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static const button = TextStyle(
    color: AppColors.textLight,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const buttonLogin = TextStyle(
    color: Color.fromARGB(255, 0, 0, 0),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}
