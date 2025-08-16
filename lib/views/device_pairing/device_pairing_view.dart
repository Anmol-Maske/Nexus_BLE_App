// views/device_pairing_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../controllers/device_pairing_controller.dart';
import 'device_details_view.dart';
import '../../utils/helpers.dart';

/// DevicePairingView:
/// Displays list of nearby BLE devices, scanning status, and connect buttons.
class DevicePairingView extends StatelessWidget {
  const DevicePairingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DevicePairingController()..startScan(),
      child: const _DevicePairingBody(),
    );
  }
}

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
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.cardMint,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                controller.isScanning ? "Scanning..." : "Scanning Stopped",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: controller.isScanning ? Colors.green : Colors.black,
                ),
              ),
            ),
          ),

          /// Device list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.startScan(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
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

      /// Floating Action Button for scan toggle (bottom right)
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 1),
                    Text(id),
                    const SizedBox(height: 1),
                    // Show just a colored dot instead of text
                    Row(
                      children: [
                        const SizedBox(width: 0),
                        Text("RSSI: $rssi"),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final controller = Provider.of<DevicePairingController>(context, listen: false);
                      await controller.stopScan();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DeviceDetailsView(device: device),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Connect'),
                  ),
                  const SizedBox(height: 0), // Distance between button and wifi symbol
                  Icon(Icons.wifi, color: getRssiColor(rssi), size: 26),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
