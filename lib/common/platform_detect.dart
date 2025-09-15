import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class PlatformDetect {
  static bool isDesktop() {
    return kIsWeb || Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  static bool isMobile() {
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool isWeb() {
    return kIsWeb;
  }
}
