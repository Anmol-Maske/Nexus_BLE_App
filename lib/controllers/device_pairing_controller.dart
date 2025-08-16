// controllers/device_pairing_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class DevicePairingController extends ChangeNotifier {
  StreamSubscription<List<ScanResult>>? _scanSub;
  Timer? _scanTimer;

  // Internal map for device deduplication
  final Map<String, ScanResult> _resultsMap = {};

  // Exposed device list for UI (sorted)
  List<ScanResult> devices = [];

  bool isScanning = false;

  DateTime _lastNotify = DateTime.fromMillisecondsSinceEpoch(0);
  final Duration _notifyThrottle = const Duration(milliseconds: 300);

  /// Ensure required runtime permissions are granted before scanning
  /// - Android 12+ requires: bluetoothScan + bluetoothConnect (advertise optional)
  /// - Android <12 requires: bluetoothScan + fine location
  /// - iOS requires nothing extra (handled by OS)
  Future<bool> ensurePermissions() async {
    if (!Platform.isAndroid) return true;

    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.locationWhenInUse, // legacy fallback
    ].request();

    final scan = statuses[Permission.bluetoothScan]?.isGranted ?? false;
    final connect = statuses[Permission.bluetoothConnect]?.isGranted ?? false;
    final advertise = statuses[Permission.bluetoothAdvertise]?.isGranted ?? false;
    final loc = statuses[Permission.locationWhenInUse]?.isGranted ?? false;

    // Android 12+ path
    if (scan && connect) return true;
    // Legacy fallback for Android <12
    if (scan && loc) return true;

    debugPrint('[FBP] Permissions missing → scan=$scan connect=$connect advertise=$advertise location=$loc');
    return false;
  }

  Future<void> startScan({Duration timeout = const Duration(seconds: 8)}) async {
    if (isScanning) return;

    if (!(await ensurePermissions())) {
      debugPrint('[FBP] Permissions not granted, aborting scan');
      return;
    }

    _resultsMap.clear();
    devices = [];
    isScanning = true;
    notifyListeners();

    await _scanSub?.cancel();
    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      for (var r in results) {
        _resultsMap[r.device.id.toString()] = r;
      }
      final now = DateTime.now();
      if (now.difference(_lastNotify) >= _notifyThrottle) {
        _lastNotify = now;
        devices = _resultsMap.values.toList()
          ..sort((a, b) => b.rssi.compareTo(a.rssi));
        debugPrint('[FBP] notify devices=${devices.length}');
        notifyListeners();
      }
    }, onError: (e) {
      debugPrint('[FBP] scanResults error: $e');
    });

    try {
      await FlutterBluePlus.stopScan();
    } catch (_) {}

    try {
      FlutterBluePlus.startScan(
        continuousUpdates: true,
        androidUsesFineLocation: true, // keep for legacy
        androidScanMode: AndroidScanMode.lowLatency,
      );
      debugPrint('[FBP] startScan called');
    } catch (e) {
      debugPrint('[FBP] startScan threw: $e');
      await stopScan();
      return;
    }

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
