import 'dart:async';
import '../models/mock_device.dart';

/// Service that simulates BLE scanning.
/// Replace with real BLE scanning logic later.
class DeviceService {
  // sample mocked devices
  final List<MockDevice> _mockDevices = [
    MockDevice(name: 'BLE Device 1', id: 'AA:BB:CC:DD:EE:FF', rssi: -65),
    MockDevice(name: 'BLE Device 2', id: 'FF:EE:DD:CC:BB:AA', rssi: -78),
  ];

  /// Simulate scanning delay and return list
  Future<List<MockDevice>> scanDevices() async {
    await Future.delayed(const Duration(seconds: 2)); // mimic scan time
    return List<MockDevice>.from(_mockDevices);
  }
}
