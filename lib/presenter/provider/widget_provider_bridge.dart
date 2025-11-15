import 'package:fast_clipboard/presenter/provider/record_proxy_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetProviderBridge extends StatefulWidget {
  final Widget child;

  const WidgetProviderBridge({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _WidgetProviderBridgeState();
}

class _WidgetProviderBridgeState extends State<WidgetProviderBridge> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecordProxyProvider())],
      child: widget.child,
    );
  }
}
