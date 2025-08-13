// controllers/device_pairing_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class DevicePairingController extends ChangeNotifier {
  StreamSubscription<List<ScanResult>>? _scanSub;
  Timer? _scanTimer;

  // internal map to dedupe by device id
  final Map<String, ScanResult> _resultsMap = {};

  // exposed list (sorted) for UI
  List<ScanResult> devices = [];

  bool isScanning = false;

  DateTime _lastNotify = DateTime.fromMillisecondsSinceEpoch(0);
  final Duration _notifyThrottle = const Duration(milliseconds: 300);

  Future<bool> ensurePermissions() async {
    if (!Platform.isAndroid) return true;

    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    final scanGranted = statuses[Permission.bluetoothScan]?.isGranted ?? false;
    final connectGranted = statuses[Permission.bluetoothConnect]?.isGranted ?? false;
    final locGranted = statuses[Permission.locationWhenInUse]?.isGranted ?? false;

    return (scanGranted && connectGranted) || (scanGranted && locGranted);
  }

  Future<void> startScan({Duration timeout = const Duration(seconds: 8)}) async {
    if (isScanning) return;

    final ok = await ensurePermissions();
    if (!ok) {
      debugPrint('[FBP] Permissions not granted, abort scan');
      return;
    }

    // clean previous state
    _resultsMap.clear();
    devices = [];
    isScanning = true;
    notifyListeners();

    // cancel previous subscription if any
    await _scanSub?.cancel();
    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      // update map with latest result for each device
      for (final r in results) {
        final id = r.device.id.toString();
        _resultsMap[id] = r;
      }

      // throttle UI updates to avoid rebuild storms
      final now = DateTime.now();
      if (now.difference(_lastNotify) >= _notifyThrottle) {
        _lastNotify = now;
        // convert map -> list, sort by rssi desc (higher/less negative first)
        final list = _resultsMap.values.toList();
        list.sort((a, b) => b.rssi.compareTo(a.rssi));
        devices = list;
        debugPrint('[FBP] notify devices=${devices.length}');
        notifyListeners();
      }
    }, onError: (e) {
      debugPrint('[FBP] scanResults error: $e');
    });

    // defensive stop before starting
    try {
      await FlutterBluePlus.stopScan();
    } catch (_) {}

    // start scan (do not await a future which may be void)
    try {
      FlutterBluePlus.startScan(
        continuousUpdates: true,
        androidUsesFineLocation: true,
        androidScanMode: AndroidScanMode.lowLatency,
      );
      debugPrint('[FBP] startScan called');
    } catch (e) {
      debugPrint('[FBP] startScan threw: $e');
      await stopScan();
      return;
    }

    // schedule stop after timeout, but allow user to call stopScan earlier
    _scanTimer?.cancel();
    _scanTimer = Timer(timeout, () async {
      debugPrint('[FBP] scan timeout reached; stopping scan');
      await stopScan();
    });
  }

  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      debugPrint('[FBP] stopScan error: $e');
    }

    _scanTimer?.cancel();
    _scanTimer = null;

    await _scanSub?.cancel();
    _scanSub = null;

    isScanning = false;
    notifyListeners();

    debugPrint('[FBP] stopScan: completed');
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _scanSub?.cancel();
    try {
      FlutterBluePlus.stopScan();
    } catch (_) {}
    super.dispose();
  }
}
