import 'package:fast_clipboard/presenter/provider/state_management.dart';
import 'package:fast_clipboard/presenter/server/default_app_service.dart';
import 'package:fast_clipboard/view/app/fast_clipboard.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await DefaultAppService.ensureInitialized();

  runApp(StateManagement(child: FastSendApp()));
}
