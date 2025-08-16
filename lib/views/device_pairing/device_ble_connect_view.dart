// device_ble_connected_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../controllers/ble_manage_services.dart';

/// This screen displays all discovered GATT services and characteristics
/// for a connected BLE device using an expandable card list UI.
///
/// All BLE-related logic (read/write/notify/etc.) is delegated to
/// [BleManageServices] to keep UI code clean and separated.
class DeviceBleConnectedView extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceBleConnectedView({super.key, required this.device});

  @override
  State<DeviceBleConnectedView> createState() => _DeviceBleConnectedViewState();
}

class _DeviceBleConnectedViewState extends State<DeviceBleConnectedView> {
  late BleManageServices _bleManager;
  List<BluetoothService> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _bleManager = BleManageServices(widget.device);
    _discoverServices();
  }

  /// Discover services using BLE Manager
  Future<void> _discoverServices() async {
    final services = await _bleManager.discoverServices();
    setState(() {
      _services = services;
      _isLoading = false;
    });
  }

  /// Handle read action
  Future<void> _onRead(BluetoothCharacteristic c) async {
    final value = await _bleManager.readCharacteristic(c);
    if (value != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Read: $value")),
      );
    }
  }

  /// Handle write action (here writing "0x01" as example)
  Future<void> _onWrite(BluetoothCharacteristic c) async {
    final success = await _bleManager.writeCharacteristic(c, [0x01]);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Write successful" : "Write failed")),
    );
  }

  /// Handle toggle notifications
  Future<void> _onToggleNotify(BluetoothCharacteristic c) async {
    final enabled = await _bleManager.toggleNotify(c);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(enabled ? "Notifications enabled" : "Notifications disabled"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.device.platformName.isNotEmpty
              ? widget.device.platformName
              : "Connected Device",
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _services.isEmpty
          ? const Center(child: Text("No GATT Services found"))
          : ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 12,
            ),
            child: ExpansionTile(
              title: Text(
                "Service: ${service.uuid}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              children: service.characteristics.map((c) {
                return ListTile(
                  leading: const Icon(Icons.extension),
                  title: Text("Characteristic: ${c.uuid}"),
                  subtitle: Text(
                    "Properties: "
                        "${c.properties.read ? "Read " : ""}"
                        "${c.properties.write ? "Write " : ""}"
                        "${c.properties.notify ? "Notify " : ""}"
                        "${c.properties.indicate ? "Indicate " : ""}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (c.properties.read)
                        IconButton(
                          icon: const Icon(Icons.download),
                          tooltip: "Read",
                          onPressed: () => _onRead(c),
                        ),
                      if (c.properties.write)
                        IconButton(
                          icon: const Icon(Icons.upload),
                          tooltip: "Write",
                          onPressed: () => _onWrite(c),
                        ),
                      if (c.properties.notify || c.properties.indicate)
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          tooltip: "Toggle Notify",
                          onPressed: () => _onToggleNotify(c),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
