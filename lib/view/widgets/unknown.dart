import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Unknown extends StatelessWidget {
  const Unknown({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: SvgPicture.asset('assets/unknown.svg', width: 120, height: 120),
      ),
    );
  }
}
