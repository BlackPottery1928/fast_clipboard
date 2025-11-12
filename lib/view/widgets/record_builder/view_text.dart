import 'package:fast_clipboard/model/contract/record_definition.dart';
import 'package:flutter/material.dart';
import 'package:rich_text_view/rich_text_view.dart';

class ViewText extends StatefulWidget {
  final String index;
  final RecordDefinition definition;
  final Function(String) onChanged;

  const ViewText({
    super.key,
    required this.index,
    required this.onChanged,
    required this.definition,
  });

  @override
  State<StatefulWidget> createState() => _ViewTextState();
}

class _ViewTextState extends State<ViewText> {
  @override
  Widget build(BuildContext context) {
    return RichTextView(
      text: widget.definition.text,
      truncate: true,
      viewLessText: '折叠',
      viewMoreText: '展开',
      selectable: true,
      maxLines: 10,
      textWidthBasis: TextWidthBasis.longestLine,
      linkStyle: TextStyle(),
      style: TextStyle(fontSize: 14),
      supportedTypes: [
        UrlParser(onTap: (matched) async {}),
        EmailParser(onTap: (v) {}),
      ],
    );
  }
}
