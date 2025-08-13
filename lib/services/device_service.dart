// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class DeviceService {
//   final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//
//   /// Start scanning for BLE devices
//   Future<List<ScanResult>> scanDevices({Duration timeout = const Duration(seconds: 5)}) async {
//     List<ScanResult> devices = [];
//
//     // Ensure no duplicate scans
//     if (flutterBlue.isScanningNow) {
//       await flutterBlue.stopScan();
//     }
//
//     // Start scan
//     await flutterBlue.startScan(timeout: timeout);
//
//     // Listen for devices
//     await for (final results in flutterBlue.scanResults) {
//       devices = results;
//       // Break after timeout
//       if (!flutterBlue.isScanningNow) break;
//     }
//
//     return devices;
//   }
//
//   /// Connect to a selected BLE device
//   Future<void> connectToDevice(BluetoothDevice device) async {
//     await device.connect(autoConnect: false);
//   }
//
//   /// Disconnect from a BLE device
//   Future<void> disconnectFromDevice(BluetoothDevice device) async {
//     await device.disconnect();
//   }
// }
