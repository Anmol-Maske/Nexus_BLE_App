import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../controllers/device_pairing_controller.dart';
import '../../models/mock_device.dart';
import 'device_details_view.dart';

/// Device Pairing screen: shows pull-to-refresh area and scanned devices.
/// Uses DevicePairingController to demonstrate separation of logic.
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
        title: const Text(AppStrings.devicesAvailable),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [

          // Scanning indicator
          if (controller.isScanning)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 12),
                  Text('Scanning for devices...'),
                ],
              ),
            ),

          // Device list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.startScan(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.devices.length,
                itemBuilder: (context, index) {
                  final MockDevice device = controller.devices[index];
                  return _deviceCard(context, device);
                },
              ),
            ),
          ),

          // Bottom bar with search & scan buttons in center
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    _roundIconButton(icon: Icons.search, onPressed: () => controller.startScan()),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceCard(BuildContext context, MockDevice device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: AppColors.cardMint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(device.id),
                    const SizedBox(height: 6),
                    Text('Rssi ${device.rssi}'),
                  ],
                ),
              ),

              // Connect button and wifi icon
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // When connected, navigate to device details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DeviceDetailsView(device: device)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Connect'),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.wifi, color: Colors.green, size: 26),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(20)),
      child: IconButton(onPressed: onPressed, icon: Icon(icon, color: Colors.white)),
    );
  }
}
