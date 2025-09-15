import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenStoreHandler {
  OpenStoreHandler._();

  static final OpenStoreHandler _instance = OpenStoreHandler._();

  static OpenStoreHandler get instance => _instance;

  static const _playMarketUrl =
      'https://play.google.com/store/apps/details?id=';
  static const _appStoreUrlIOS = 'https://apps.apple.com/app/id';
  static const _appStoreUrlMacOS =
      'https://apps.apple.com/ru/app/g-app-launcher/id';
  static const _microsoftStoreUrl = 'https://apps.microsoft.com/store/detail/';

  ///程序会依次打开这些应用商场，如果有安装的话，如果已经被打开则拦截后续的打开，根据市场需求排序吧
  final List<String> _marketUrls = [
    // 不清楚，但通用
    "market://details?id=com.tencent.mm",
    // vivo 专用
    "vivomarket://details?id=com.tencent.mm",
    // 小米 专用
    "mimarket://details?id=com.tencent.mm",
    // 华为 专用
    "appmarket://details?id=com.tencent.mm",
    // oppo 专用
    "oppomarket://details?packagename=com.tencent.mm",
    // 鸿蒙 专用
    "store://appgallery.huawei.com/app/detail?id=com.tencent.mm",
    // 腾讯应用宝
    "tmast://appdetails?pname=com.tencent.mm",
  ];

  final _platformNotSupportedException = Exception('Platform not supported');

  Future<void> open({
    String? androidAppBundleId,
    String? appStoreId,
    String? linuxStoreId,
    String? appStoreIdMacOS,
    String? windowsProductId,
  }) async {
    assert(
      appStoreId != null ||
          androidAppBundleId != null ||
          windowsProductId != null ||
          appStoreIdMacOS != null,
      "You must pass one of this parameters",
    );

    try {
      await _open(
        appStoreId,
        appStoreIdMacOS,
        androidAppBundleId,
        windowsProductId,
      );
    } on Exception catch (e, st) {
      rethrow;
    }
  }

  Future<void> _open(
    String? appStoreId,
    String? appStoreIdMacOS,
    String? androidAppBundleId,
    String? windowsProductId,
  ) async {
    if (kIsWeb) {
      throw Exception('Platform not supported');
    }

    if (Platform.isIOS) {
      await _openIOS(appStoreId);
      return;
    }
    if (Platform.isMacOS) {
      await _openMacOS(appStoreId, appStoreIdMacOS);
      return;
    }
    if (Platform.isAndroid) {
      await _openAndroid(androidAppBundleId);
      return;
    }
    if (Platform.isWindows) {
      await _opnWindows(windowsProductId);
      return;
    }

    throw _platformNotSupportedException;
  }

  Future _openAndroid(String? androidAppBundleId) async {
    if (androidAppBundleId != null) {
      await _openUrl('$_playMarketUrl$androidAppBundleId');
      return;
    }
    throw CantLaunchPageException("androidAppBundleId is not passed");
  }

  Future _openIOS(String? appStoreId) async {
    if (appStoreId != null) {
      await _openUrl('$_appStoreUrlIOS$appStoreId');
      return;
    }
    throw CantLaunchPageException("appStoreId is not passed");
  }

  Future _openMacOS(String? appStoreId, String? appStoreIdMacOS) async {
    if (appStoreId != null || appStoreIdMacOS != null) {
      await _openUrl('$_appStoreUrlMacOS${appStoreIdMacOS ?? appStoreId}');
      return;
    }
    throw CantLaunchPageException(
      "appStoreId and appStoreIdMacOS is not passed",
    );
  }

  Future _opnWindows(String? windowsProductId) async {
    if (windowsProductId != null) {
      await _openUrl('$_microsoftStoreUrl$windowsProductId');
      return;
    }
    throw CantLaunchPageException("windowsProductId is not passed");
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    throw CantLaunchPageException('Could not launch $url');
  }
}

/// Common package exception
class OpenStoreException implements Exception {
  String cause;

  OpenStoreException(this.cause);
}

/// This exception was thrown when page in store can't be launchd
class CantLaunchPageException extends OpenStoreException {
  CantLaunchPageException(String cause) : super(cause);
}
