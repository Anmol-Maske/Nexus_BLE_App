import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

/// Reusable rounded red button used on home screen.
/// Screen-specific widget (placed in home/widgets/)
class HomeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const HomeButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
