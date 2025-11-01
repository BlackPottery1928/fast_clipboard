import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rich_text_view/rich_text_view.dart';

class TextItem extends StatefulWidget {
  final int i;

  const TextItem({super.key, required this.i});

  @override
  State<StatefulWidget> createState() => _TextItemState();
}

class _TextItemState extends State<TextItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Gap(12),
        Stack(
          children: [
            ClipRRect(
              child: Container(
                height: 280,
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: widget.i % 3 == 0
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
                          text:
                              '''当地时间10月30日上午国中美关系发展再次迎来重要时刻 www.janedoe.com''',
                          truncate: true,
                          viewLessText: '折叠',
                          viewMoreText: '展开',
                          selectable: true,
                          maxLines: 10,
                          textWidthBasis: TextWidthBasis.longestLine,
                          linkStyle: TextStyle(),
                          style: TextStyle(fontSize: 14),
                          supportedTypes: [
                            UrlParser(onTap: (v) {}),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '文本',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                Text(
                                  '123字符',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 48,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(6),
              SizedBox(
                height: 14,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildLine(),
                    Container(
                      decoration: BoxDecoration(
                        color: widget.i % 3 == 0
                            ? Theme.of(context).primaryColor
                            : Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 13,
                      height: 13,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: widget.i % 3 == 0
                            ? Colors.transparent
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
              ),
              Text('三分钟前', style: TextStyle(fontSize: 10, color: Colors.black87)),
            ],
          ),
        ),
      ],
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
