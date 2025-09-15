import 'package:fast_clipboard/common/device.dart';
import 'package:flutter/material.dart';

class HardwareDetect extends StatefulWidget {
  const HardwareDetect({super.key});

  @override
  State<HardwareDetect> createState() => _HardwareDetectState();
}

class _HardwareDetectState extends State<HardwareDetect> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: FutureBuilder<Map<String, String>>(
        future: Device.getDeviceInfo(),
        builder: (context, snapshot) {
          return Container(
            height: 140,
            width: 140,
            color: Colors.white,
            child: Icon(Device.getDeviceIcon(), size: 52),
          );
        },
      ),
    );
  }
}
