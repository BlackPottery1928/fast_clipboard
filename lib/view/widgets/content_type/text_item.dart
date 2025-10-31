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
                height: 288,
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 288,
                width: 280,
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
                              '''当地时间10月30日上午国家主席习近平乘专机抵达韩国，应大韩民国总统李在明邀请，出席亚太经合组织第三十二次领导人非正式会议并对韩国进行国事访问。随后，习近平同美国总统特朗普举行会晤。在这场举世瞩目、长达约100分钟的中美元首会晤上，习近平主席的发言掷地有声：“两国做伙伴、做朋友，这是历史的启示，也是现实的需要”“中美两国完全可以相互成就、共同繁荣”“双方应该算大账”“让中美关系这艘大船平稳前行”，传递掌舵领航、稳控大局的责任与担当，字字千钧。在釜山，中美关系发展再次迎来重要时刻 www.janedoe.com''',
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
          height: 42,
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

    canvas.drawLine(Offset(0, 0), Offset(145, 0), paint);
    canvas.drawLine(Offset(-145, 0), Offset(0, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
