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
    return SizedBox(
      height: 330,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (c, i) {
          return TextItem(i: i);
        },
        separatorBuilder: (context, index) {
          return const Gap(12);
        },
        itemCount: 30,
      ),
    );
  }
}
