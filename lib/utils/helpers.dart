/// Small helper functions you can expand later
String rssiToQuality(int rssi) {
  if (rssi >= -50) return 'Excellent';
  if (rssi >= -70) return 'Good';
  return 'Weak';
}
