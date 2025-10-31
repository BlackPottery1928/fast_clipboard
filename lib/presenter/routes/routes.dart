import 'package:fast_clipboard/view/app/home.dart';
import 'package:fast_clipboard/view/app/bottom_sheet_transfer_process.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return FastSendDesktopHomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'process',
            builder: (BuildContext context, GoRouterState state) {
              return BottomSheetTransferProcess();
            },
          ),
        ],
      ),
    ],
  );
}
