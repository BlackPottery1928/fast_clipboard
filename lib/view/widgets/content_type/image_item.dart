import 'dart:typed_data';

import 'package:fast_clipboard/view/theme/view_region.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';

class ImageItem extends StatefulWidget {
  final int no;

  final String index;
  final Uint8List? image;
  final int length;
  final bool isSelected;
  final bool first;
  final bool last;
  final DateTime updated;
  final Function(String) onChanged;

  const ImageItem({
    super.key,
    required this.no,
    this.first = false,
    this.last = false,
    required this.index,
    required this.image,
    required this.isSelected,
    required this.length,
    required this.updated,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.first ? ViewRegion.scaffoldBodyGap : 0,
        right: widget.last ? ViewRegion.scaffoldBodyGap : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(5),
          GestureDetector(
            onTap: () {
              widget.onChanged(widget.index.toString());
            },
            child: SizedBox(
              height: 286,
              child: Stack(
                children: [
                  Container(
                    height: 270,
                    width: 270,
                    decoration: BoxDecoration(
                      color: HexColor('#FEFEFE'),
                      borderRadius: BorderRadius.circular(
                        ViewRegion.scaffoldBodyRadius,
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1.0, 2.0),
                          blurRadius: 4.0,
                          color: Colors.black12,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(
                              left: ViewRegion.scaffoldBodyGap,
                              top: ViewRegion.scaffoldBodyGap,
                              right: ViewRegion.scaffoldBodyGap,
                              bottom: 6,
                            ),
                            child: PhotoView(
                              imageProvider: MemoryImage(
                                widget.image!,
                                scale: 1.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(.3),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                ViewRegion.scaffoldBodyRadius,
                              ),
                              bottomRight: Radius.circular(
                                ViewRegion.scaffoldBodyRadius,
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsetsGeometry.only(
                                    left: ViewRegion.scaffoldBodyGap,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SelectableText(
                                        '图片',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SelectableText(
                                        filesize(widget.length),
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                  ClipRRect(
                    child: Container(
                      height: 270,
                      width: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ViewRegion.scaffoldBodyRadius,
                        ),
                        border: Border.all(
                          color: widget.isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          width: 2.8,
                        ),
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
                            : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 10,
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? Colors.transparent
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 7,
                      height: 7,
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
      ..color = HexColor('#FAFAFC')
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(Offset(0, 0), Offset(142, 0), paint);
    canvas.drawLine(Offset(-142, 0), Offset(0, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
