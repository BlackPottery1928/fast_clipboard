import 'package:fast_clipboard/presenter/provider/transfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StateManagement extends StatefulWidget {
  final Widget child;

  const StateManagement({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _StateManagementState();
}

class _StateManagementState extends State<StateManagement> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransferProvider()),
      ],
      child: widget.child,
    );
  }
}
