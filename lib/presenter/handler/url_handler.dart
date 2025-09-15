import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHandler {
  UrlHandler._();

  static final UrlHandler _instance = UrlHandler._();

  static UrlHandler get instance => _instance;

  void showAppStore({required BuildContext context}) {}

  void showAppWeb({required BuildContext context}) {
    // showWeb(context: context, url: 'www.baidu.com');
    showWeb(context: context, url: 'market://details?id=com.tencent.mm');
  }

  void showWeb({required BuildContext context, required String url}) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
