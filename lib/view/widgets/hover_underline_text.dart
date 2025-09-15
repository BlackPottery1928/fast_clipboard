import 'package:flutter/material.dart';

class HoverUnderlineText extends StatefulWidget {
  final AsyncSnapshot<Map<String, String>> snapshot;
  final TextStyle style;

  const HoverUnderlineText({
    super.key,
    this.style = const TextStyle(),
    required this.snapshot,
  });

  @override
  State<HoverUnderlineText> createState() => _HoverUnderlineTextState();
}

class _HoverUnderlineTextState extends State<HoverUnderlineText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // 鼠标进入时触发
      onEnter: (_) => setState(() => _isHovered = true),
      // 鼠标离开时触发
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        mouseCursor: MouseCursor.uncontrolled,
        child: Text(
          widget.snapshot.data?['deviceName'] ?? '未知设备',
          style: widget.style.copyWith(
            decoration: _isHovered
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationThickness: 1,
            decorationStyle: TextDecorationStyle.dashed,
            decorationColor:
                widget.style.color ??
                Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
