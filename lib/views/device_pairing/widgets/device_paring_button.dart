import 'package:flutter/material.dart';

/// Example small widget specific to device_pairing (kept for structure)
class DevicePairingButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const DevicePairingButton({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onTap, child: Text(label));
  }
}
