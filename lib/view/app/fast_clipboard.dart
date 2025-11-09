import 'package:fast_clipboard/presenter/routes/routes.dart';
import 'package:fast_clipboard/view/widgets/horizontal_mouse_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hexcolor/hexcolor.dart';

class FastClipboardApp extends StatelessWidget {
  const FastClipboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: Routes.router,
      theme: ThemeData(
        primaryColor: HexColor('#0B57D0'),
        colorScheme: ColorScheme.fromSeed(seedColor: HexColor('#0B57D0')),
      ),
      locale: const Locale('zh', 'CN'),
      supportedLocales: [const Locale('zh', 'CN'), const Locale('en', 'US')],
      scrollBehavior: HorizontalMouseScrollBehavior(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
