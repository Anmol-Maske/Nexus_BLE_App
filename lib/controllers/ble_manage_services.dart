// ble_manage_services.dart
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/foundation.dart';

/// BLE Manager class to handle all technical BLE operations
/// like discovering services, reading/writing characteristics,
/// and enabling/disabling notifications.
///
/// This ensures UI code remains clean and all BLE logic is centralized.
class BleManageServices {
  final BluetoothDevice device;

  BleManageServices(this.device);

  /// Discover all available GATT services for the connected device
  Future<List<BluetoothService>> discoverServices() async {
    try {
      return await device.discoverServices();
    } catch (e) {
      debugPrint("Error discovering services: $e");
      return [];
    }
  }

  /// Read characteristic value
  Future<List<int>?> readCharacteristic(BluetoothCharacteristic c) async {
    try {
      return await c.read();
    } catch (e) {
      debugPrint("Read error: $e");
      return null;
    }
  }

  /// Write value to characteristic
  Future<bool> writeCharacteristic(
      BluetoothCharacteristic c, List<int> value) async {
    try {
      await c.write(value, withoutResponse: false);
      return true;
    } catch (e) {
      debugPrint("Write error: $e");
      return false;
    }
  }

  /// Toggle notifications (enable/disable) for a characteristic
  Future<bool> toggleNotify(BluetoothCharacteristic c) async {
    try {
      final isNotifying = c.isNotifying;
      await c.setNotifyValue(!isNotifying);

      // Listen for notifications if just enabled
      if (!isNotifying) {
        c.lastValueStream.listen((value) {
          debugPrint("Notification from ${c.uuid}: $value");
        });
      }

      return !isNotifying; // return new state
    } catch (e) {
      debugPrint("Notify error: $e");
      return false;
    }
  }
}
