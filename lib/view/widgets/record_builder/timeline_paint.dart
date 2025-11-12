import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TimelinePaint extends StatefulWidget {
  const TimelinePaint({super.key});

  @override
  State<StatefulWidget> createState() => _TimelinePaintState();
}

class _TimelinePaintState extends State<TimelinePaint> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: LineIndicatorPainter());
  }
}

class LineIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = HexColor('#FAFAFC')
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(Offset(0, 0), Offset(142, 0), paint);
    canvas.drawLine(Offset(-142, 0), Offset(0, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
