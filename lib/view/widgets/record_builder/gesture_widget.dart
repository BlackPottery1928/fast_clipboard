import 'package:fast_clipboard/view/theme/view_region.dart';
import 'package:flutter/material.dart';

class GestureWidget extends StatefulWidget {
  final bool first;
  final bool last;
  final Widget child;
  final VoidCallback onTap;

  const GestureWidget({
    super.key,
    required this.first,
    required this.last,
    required this.child,
    required this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _GestureWidgetState();
}

class _GestureWidgetState extends State<GestureWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.first ? ViewRegion.scaffoldBodyGap : 0,
        right: widget.last ? ViewRegion.scaffoldBodyGap : 0,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 5),
        child: GestureDetector(
          onTap: widget.onTap,
          child: SizedBox(height: 286, child: widget.child),
        ),
      ),
    );
  }
}
