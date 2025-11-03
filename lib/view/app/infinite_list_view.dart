import 'package:fast_clipboard/presenter/provider/records_provider.dart';
import 'package:fast_clipboard/view/widgets/content_type/text_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class InfiniteListView extends StatefulWidget {
  const InfiniteListView({super.key});

  @override
  State<StatefulWidget> createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  @override
  Widget build(BuildContext context) {
    RecordsProvider provider = Provider.of<RecordsProvider>(context);
    return SizedBox(
      height: 330,
      width: MediaQuery.of(context).size.width,
      child: Visibility(
        visible: provider.linked.isNotEmpty,
        replacement: const Center(child: Text('复制的数据将显示在这里')),
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return TextItem(
              index: provider.linked[index].idx,
              text: provider.linked[index].value,
              length: provider.linked[index].length,
              isSelected: provider.linked[index].selected,
              onChanged: (String idx) {
                Provider.of<RecordsProvider>(
                  context,
                  listen: false,
                ).toggleSelection(idx);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Gap(12);
          },
          itemCount: provider.linked.length,
        ),
      ),
    );
  }
}
