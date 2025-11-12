import 'package:fast_clipboard/view/desktop/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return FastClipboardHomePage();
        },
        routes: <RouteBase>[

        ],
      ),
    ],
  );
}
