import 'package:fast_clipboard/view/widgets/content_type/text_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InfiniteListView extends StatefulWidget {
  const InfiniteListView({super.key});

  @override
  State<StatefulWidget> createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      height: 340,
      child: ListView.separated(
        padding: EdgeInsetsGeometry.zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (c, i) {
          return Row(
            children: [
              Gap(i <= 0 ? 12 : 0),
              TextItem(i: i),
            ],
          );
        },
        separatorBuilder: (a, c) {
          return Gap(12);
        },
        itemCount: 20,
      ),
    );
  }
}
