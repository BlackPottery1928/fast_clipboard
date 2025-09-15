import 'package:fast_clipboard/presenter/routes/routes.dart';
import 'package:flutter/material.dart';

class FastSendApp extends StatelessWidget {
  const FastSendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: Routes.router,
    );
  }
}
