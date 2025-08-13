import 'package:flutter/material.dart';
import '../../config/app_strings.dart';

/// Placeholder screen for Beacon Logger (you'll expand it later).
class BeaconLoggerView extends StatelessWidget {
  const BeaconLoggerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.beaconLoggerTitle)),
      body: const Center(child: Text('Beacon Logger - Coming soon')),
    );
  }
}
