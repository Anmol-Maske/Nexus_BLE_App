import 'package:flutter/material.dart';

/// Centralized app color palette.
/// Use these constants across the app for consistent theming.
class AppColors {
  /// Primary accent blue used for highlights and buttons.
  static const Color primaryBlue = Color(0xFF1B9ACD);

  /// Card background (light gray shade).
  /// Using `fromARGB` since `Colors.grey.shade300` is not const.
  static const Color cardMint = Color.fromARGB(255, 224, 224, 224);

  /// App background color (default: white).
  static const Color background = Colors.white;

  /// Primary text color (updated to white for "Devices Available").
  static const Color textPrimary = Colors.white;

  /// Secondary text color (subtle gray).
  static const Color textSecondary = Colors.grey;
}
