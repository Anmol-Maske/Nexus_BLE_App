import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../models/mock_device.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';

/// Device details page shown after "Connect" is tapped.
/// Matches the fingerprint + two red icons layout in your screenshot.
class DeviceDetailsView extends StatelessWidget {
  final BluetoothDevice device;

  const DeviceDetailsView({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.deviceInformation),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          // Device info card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: AppColors.cardMint,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                trailing: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.bluetooth, color: Colors.white),
                ),
              ),
            ),
          ),

          // Spacer to center fingerprint button near bottom
          const Expanded(child: SizedBox()),

          const SizedBox(height: 22),

          // Two small square red action icons below fingerprint (settings & doc)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _smallSquareButton(icon: Icons.settings, onTap: () {}),
              const SizedBox(width: 14),
              _smallSquareButton(icon: Icons.article, onTap: () {}),
            ],
          ),

          const SizedBox(height: 22),

        ],
      ),
    );
  }

  Widget _smallSquareButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
