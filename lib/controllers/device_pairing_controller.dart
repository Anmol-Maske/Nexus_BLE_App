import 'package:flutter/foundation.dart';
import '../models/mock_device.dart';
import '../services/device_service.dart';

/// Controller for device pairing screen.
/// (Added into controllers/ folder to keep scanning logic outside UI)
class DevicePairingController extends ChangeNotifier {
  final DeviceService _service = DeviceService();
  List<MockDevice> devices = [];
  bool isScanning = false;

  /// Start simulated scan and update state
  Future<void> startScan() async {
    isScanning = true;
    notifyListeners();

    devices = await _service.scanDevices();

    isScanning = false;
    notifyListeners();
  }
}
