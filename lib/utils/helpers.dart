import 'package:flutter/material.dart';

Color getRssiColor(int rssi) {
  if (rssi >= -50) return Colors.green;     // Excellent
  if (rssi >= -70) return Colors.orange;    // Good
  return Colors.red;                        // Weak
}
