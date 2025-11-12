import 'package:fast_clipboard/model/contract/record_definition.dart';
import 'package:fast_clipboard/view/theme/view_region.dart';
import 'package:fast_clipboard/view/widgets/record_builder/drag_widget.dart';
import 'package:fast_clipboard/view/widgets/record_builder/gesture_widget.dart';
import 'package:fast_clipboard/view/widgets/record_builder/timeline_paint.dart';
import 'package:fast_clipboard/view/widgets/record_builder/view_file.dart';
import 'package:fast_clipboard/view/widgets/record_builder/view_image.dart';
import 'package:fast_clipboard/view/widgets/record_builder/view_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:hexcolor/hexcolor.dart';

class RecordCard extends StatefulWidget {
  final String index;
  final bool isSelected;
  final bool first;
  final bool last;
  final RecordDefinition definition;
  final Function(RecordDefinition) onChanged;

  const RecordCard({
    super.key,
    required this.index,
    required this.isSelected,
    required this.first,
    required this.last,
    required this.onChanged,
    required this.definition,
  });

  @override
  State<StatefulWidget> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  @override
  Widget build(BuildContext context) {
    return GestureWidget(
      first: widget.first,
      last: widget.last,
      onTap: () {
        widget.onChanged(widget.definition);
      },
      child: DragWidget(
        child: Stack(
          children: [
            _buildBoxDecoration(
              _buildRecordBodyWidget(widget.definition),
              _buildRecordFooterWidget(widget.definition),
            ),
            _buildSelectedBoxDecoration(widget.isSelected),
            _buildAppSourceLogo(widget.definition),
            _buildTimeline(widget.definition),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordBodyWidget(RecordDefinition definition) {
    Widget child;
    if (definition.type == "text") {
      child = ViewText(
        index: definition.idx,
        onChanged: (String p1) {},
        definition: definition,
      );
    } else if (definition.type == "image") {
      child = ViewImage(index: definition.idx, image: definition.image);
    } else if (definition.type == "file") {
      child = ViewFile(index: definition.idx, files: definition.files);
    } else {
      child = Container();
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(constraints: constraints, child: child);
      },
    );
  }

  Widget _buildRecordFooterWidget(RecordDefinition definition) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ViewRegion.scaffoldBodyRadius),
          bottomRight: Radius.circular(ViewRegion.scaffoldBodyRadius),
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
              child: _buildRecordTyped(definition),
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
    );
  }

  Widget _buildRecordTyped(RecordDefinition definition) {
    String type = '未知';
    if (definition.type == "text") {
      type = '文本';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText(
          type,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SelectableText(
          '字符',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildTimeline(RecordDefinition definition) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 34,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(2),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(alignment: Alignment.center, child: TimelinePaint()),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 10,
                    height: 10,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? Colors.transparent
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 7,
                    height: 7,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18,
              child: SelectableText(
                GetTimeAgo.parse(definition.updated, locale: 'zh'),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxDecoration(Widget body, Widget footer) {
    return Container(
      height: 270,
      width: 270,
      decoration: BoxDecoration(
        color: HexColor('#FEFEFE'),
        borderRadius: BorderRadius.circular(ViewRegion.scaffoldBodyRadius),
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
              child: body,
            ),
          ),
          footer,
        ],
      ),
    );
  }

  Widget _buildSelectedBoxDecoration(bool selected) {
    return ClipRRect(
      child: Container(
        height: 270,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ViewRegion.scaffoldBodyRadius),
          border: Border.all(
            color: selected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2.8,
          ),
        ),
      ),
    );
  }

  Widget _buildAppSourceLogo(RecordDefinition definition) {
    return SizedBox(
      height: 296,
      width: 270,
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: []),
    );
  }
}
