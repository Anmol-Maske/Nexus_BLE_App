// views/device_details_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// App config imports
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';

// Import the GATT Services/Characteristics screen
import '../../views/device_pairing/device_ble_connect_view.dart';

/// Device details page shown after "Connect" is tapped.
/// Layout: Device name + ID on left, Disconnect button on right.
/// Features:
///   - Disconnect when pressing back (AppBar/system back button).
///   - Disconnect when app is closed or screen is disposed.
///   - Navigate to GATT services/characteristics screen (settings button).
class DeviceDetailsView extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceDetailsView({super.key, required this.device});

  @override
  State<DeviceDetailsView> createState() => _DeviceDetailsViewState();
}

class _DeviceDetailsViewState extends State<DeviceDetailsView> {
  @override
  void dispose() {
    // Ensure device is disconnected when widget is removed (e.g., app closed/killed)
    _disconnectDevice();
    super.dispose();
  }

  /// Helper to disconnect device safely
  Future<void> _disconnectDevice() async {
    try {
      await widget.device.disconnect();
      debugPrint("Device disconnected.");
    } catch (e) {
      debugPrint("Error while disconnecting: $e");
    }
  }

  /// Handle back button press (AppBar/system back)
  Future<bool> _onWillPop() async {
    await _disconnectDevice();
    return true; // allow navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercepts back button
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.deviceInformation),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _disconnectDevice();
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            // =========================
            // Device Row (Name + ID + Disconnect Button)
            // =========================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardMint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side → Device Name + ID
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.device.platformName.isNotEmpty
                              ? widget.device.platformName
                              : "Unknown Device",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.device.remoteId.str,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    // Right side → Disconnect Button
                    ElevatedButton(
                      onPressed: () async {
                        await _disconnectDevice();
                        if (mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // pill shape
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text("Disconnect"),
                    ),
                  ],
                ),
              ),
            ),

            // Spacer → Pushes the bottom buttons down
            const Expanded(child: SizedBox()),

            // =========================
            // Two Action Buttons (Settings + Docs)
            // =========================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SETTINGS button → opens device_ble_connected_view.dart
                _smallSquareButton(
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DeviceBleConnectedView(device: widget.device),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 14),

                // DOCS button → Placeholder for now
                _smallSquareButton(icon: Icons.article, onTap: () {}),
              ],
            ),

            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }

  /// Helper for bottom small square buttons
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
