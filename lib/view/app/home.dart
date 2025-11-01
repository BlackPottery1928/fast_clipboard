import 'package:fast_clipboard/view/app/infinite_list_view.dart';
import 'package:fast_clipboard/view/app/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class FastSendDesktopHomePage extends StatefulWidget {
  const FastSendDesktopHomePage({super.key});

  @override
  State<FastSendDesktopHomePage> createState() =>
      _FastSendDesktopHomePageState();
}

class _FastSendDesktopHomePageState extends State<FastSendDesktopHomePage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.addPostFrameCallback((c) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#edf0f2'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Toolbar(), InfiniteListView()],
        ),
      ),
    );
  }
}
