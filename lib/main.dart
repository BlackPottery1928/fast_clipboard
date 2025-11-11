import 'package:fast_clipboard/presenter/app_manager.dart';
import 'package:fast_clipboard/presenter/provider/state_management.dart';
import 'package:fast_clipboard/view/fast_clipboard.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await appManager.initialized();

  runApp(StateManagement(child: FastClipboardApp()));
}
