// views/device_pairing_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../controllers/ble_controller.dart';
import 'device_details_view.dart';
import '../../utils/helpers.dart';

/// DevicePairingView:
/// Root widget for scanning and connecting to nearby BLE devices.
class DevicePairingView extends StatelessWidget {
  const DevicePairingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Start scanning as soon as view is opened
      create: (_) => DevicePairingController()..startScan(),
      child: const _DevicePairingBody(),
    );
  }
}

/// Private body widget with UI and state listening
class _DevicePairingBody extends StatelessWidget {
  const _DevicePairingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DevicePairingController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          AppStrings.devicesAvailable,
          style: TextStyle(
            color: Colors.white, // <-- force white text for title
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [
          /// Top status bar for scanning indicator
          Container(
            width: double.infinity,
            color: AppColors.cardMint,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                controller.isScanning ? "Scanning..." : "Scanning Stopped",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: controller.isScanning ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),

          /// Expandable device list with pull-to-refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.startScan(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.devices.length,
                itemBuilder: (context, index) {
                  final ScanResult result = controller.devices[index];
                  return _deviceCard(context, result);
                },
              ),
            ),
          ),
        ],
      ),

      /// Floating Action Button for scan toggle
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        onPressed: () {
          if (controller.isScanning) {
            controller.stopScan();
          } else {
            controller.startScan();
          }
        },
        child: Icon(
          controller.isScanning ? Icons.stop : Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Device card widget
  Widget _deviceCard(BuildContext context, ScanResult result) {
    final BluetoothDevice device = result.device;
    final String name = (device.name.isNotEmpty) ? device.name : "Unknown Device";
    final String id = device.id.toString();
    final int rssi = result.rssi;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Card(
        color: AppColors.cardMint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Device info section (left)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 2),
                    Text(id, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 2),
                    Text("RSSI: $rssi", style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),

              /// Action section (right: Connect button + RSSI icon)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final controller =
                      Provider.of<DevicePairingController>(context, listen: false);
                      await controller.stopScan();

                      try {
                        // Try connecting to device
                        await device.connect(timeout: const Duration(seconds: 8));

                        // Navigate to details page if connected
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DeviceDetailsView(device: device),
                          ),
                        );
                      } catch (e) {
                        // Show snackbar if connection fails
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Connection failed: $e")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Connect'),
                  ),
                  const SizedBox(height: 6),

                  /// Wi-Fi icon colored by signal strength
                  Icon(Icons.wifi, color: getRssiColor(rssi), size: 28),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
