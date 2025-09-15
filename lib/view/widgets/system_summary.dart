import 'package:fast_clipboard/common/device.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'hover_underline_text.dart';

class SystemSummary extends StatefulWidget {
  const SystemSummary({super.key});

  @override
  State<SystemSummary> createState() => _SystemSummaryState();
}

class _SystemSummaryState extends State<SystemSummary> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: Device.getDeviceInfo(),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(12),
            HoverUnderlineText(snapshot: snapshot),
            Gap(6),
            Text(
              snapshot.data?['productName'] ?? '未知系统',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        );
      },
    );
  }
}
