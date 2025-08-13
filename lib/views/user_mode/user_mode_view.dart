import 'package:flutter/material.dart';
import '../../config/app_strings.dart';

/// Placeholder for User Mode screen
class UserModeView extends StatelessWidget {
  const UserModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.userModeTitle)),
      body: const Center(child: Text('User Mode - Coming soon')),
    );
  }
}
