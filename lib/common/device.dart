import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Device {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, String>> getDeviceInfo() async {
    Map<String, String> info = {};
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      info['deviceName'] = androidInfo.name;
      info['productName'] = androidInfo.model;
      info['uniqueId'] = androidInfo.id;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      info['deviceName'] = iosInfo.utsname.machine;
      info['productName'] = iosInfo.utsname.machine;
      info['uniqueId'] = iosInfo.identifierForVendor.toString();
    }

    if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await _deviceInfo.macOsInfo;
      info['deviceName'] = macInfo.computerName;
      info['productName'] = macInfo.osRelease;
      info['uniqueId'] = macInfo.systemGUID.toString();
    }

    if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await _deviceInfo.linuxInfo;
      info['deviceName'] = linuxInfo.prettyName;
      info['productName'] = linuxInfo.prettyName;
      info['uniqueId'] = linuxInfo.prettyName;
    }

    if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await _deviceInfo.windowsInfo;
      info['deviceName'] = windowsInfo.computerName;
      info['productName'] = windowsInfo.productName;
      info['uniqueId'] = windowsInfo.deviceId;
    }

    if (info['deviceName'] == null) {
      info['deviceName'] = '未知设备名称';
    }

    if (info['productName'] == null) {
      info['productName'] = '未知系统';
    }
    return info;
  }

  static IconData getDeviceIcon() {
    if (Platform.isAndroid) {
      return Icons.android;
    } else if (Platform.isIOS) {
      return Icons.phone_iphone;
    } else if (Platform.isMacOS) {
      return Icons.laptop_mac;
    } else if (Platform.isLinux) {
      return Icons.laptop;
    } else if (Platform.isWindows) {
      return Icons.desktop_windows;
    } else if (Platform.isFuchsia) {
      return Icons.desktop_windows;
    } else if (kIsWeb) {
      return Icons.web;
    }

    return Icons.devices;
  }

  static IconData getDeviceIconByType(String name) {
    if ("Android" == name) {
      return Icons.android;
    } else if ("IOS" == name) {
      return Icons.phone_iphone;
    } else if ("MacOS" == name) {
      return Icons.laptop_mac;
    } else if ("Linux" == name) {
      return Icons.laptop;
    } else if ("Windows" == name) {
      return Icons.desktop_windows;
    } else if ("Fuchsia" == name) {
      return Icons.desktop_windows;
    } else if ("Web" == name) {
      return Icons.web;
    }

    return Icons.devices;
  }

  static String getDeviceTypeName() {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "IOS";
    } else if (Platform.isMacOS) {
      return "MacOS";
    } else if (Platform.isLinux) {
      return "Linux";
    } else if (Platform.isWindows) {
      return "Windows";
    } else if (Platform.isFuchsia) {
      return "Fuchsia";
    } else if (kIsWeb) {
      return "Web";
    }

    return "Unknown";
  }
}
