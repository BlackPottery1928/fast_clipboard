import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 自定义滚动行为：滚轮直接映射横向滚动
class HorizontalMouseScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
