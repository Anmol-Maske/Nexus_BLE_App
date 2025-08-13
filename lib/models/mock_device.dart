/// Model for a mocked BLE device used in demo scanning
class MockDevice {
  final String name;
  final String id;
  final int rssi;

  MockDevice({required this.name, required this.id, required this.rssi});
}
