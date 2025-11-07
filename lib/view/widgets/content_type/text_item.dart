import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:rich_text_view/rich_text_view.dart';

class TextItem extends StatefulWidget {
  final int no;

  final String index;
  final String text;
  final int length;
  final bool isSelected;
  final bool first;
  final bool last;
  final DateTime updated;
  final Function(String) onChanged;

  const TextItem({
    super.key,
    required this.no,
    this.first = false,
    this.last = false,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.length,
    required this.updated,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _TextItemState();
}

class _TextItemState extends State<TextItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.first ? 12 : 0,
        right: widget.last ? 12 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              widget.onChanged(widget.index.toString());
            },
            child: SizedBox(
              height: 296,
              child: Stack(
                children: [
                  ClipRRect(
                    child: Container(
                      height: 280,
                      width: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: widget.isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          width: 2.4,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 280,
                      width: 270,
                      decoration: BoxDecoration(color: Colors.black12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsGeometry.only(
                                left: 12,
                                top: 12,
                                right: 12,
                                bottom: 6,
                              ),
                              child: RichTextView(
                                text: widget.text,
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
                              ),
                            ),
                          ),
                          Container(
                            height: 48,
                            color: Colors.black12,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SelectableText(
                                          '文本',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SelectableText(
                                          '${widget.length} 字符',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.zero,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 296,
                    width: 270,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 34,
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(6),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildLine(),
                    Container(
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 8,
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? Colors.transparent
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                  child: SelectableText(
                    GetTimeAgo.parse(widget.updated, locale: 'zh'),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomPaint _buildLine() {
    return CustomPaint(painter: LineIndicatorPainter());
  }
}

class LineIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(Offset(0, 0), Offset(140, 0), paint);
    canvas.drawLine(Offset(-140, 0), Offset(0, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
