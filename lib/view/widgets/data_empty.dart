import 'package:flutter/material.dart';

class DataEmpty extends StatelessWidget {
  const DataEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '剪切板数据将显示在这里',
        style: TextStyle(fontSize: 22, color: Colors.grey),
      ),
    );
  }
}
