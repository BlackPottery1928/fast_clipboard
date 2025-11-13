import 'package:fast_clipboard/model/contract/record_proxy.dart';
import 'package:fast_clipboard/presenter/provider/record_proxy_provider.dart';
import 'package:fast_clipboard/view/theme/view_region.dart';
import 'package:fast_clipboard/view/widgets/data_empty.dart';
import 'package:fast_clipboard/view/widgets/record_builder/record_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<StatefulWidget> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    RecordProxyProvider provider = Provider.of<RecordProxyProvider>(context);
    return SizedBox(
      height: ViewRegion.scaffoldBodyHeight,
      width: MediaQuery.maybeWidthOf(context),
      child: Visibility(
        visible: provider.proxys.isNotEmpty,
        replacement: DataEmpty(),
        child: _buildInfiniteScrollList(provider.proxys),
      ),
    );
  }

  Widget _buildInfiniteScrollList(List<RecordProxy> linked) {
    return ListView.separated(
      shrinkWrap: true,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        RecordProxy proxy = linked[index];
        return RecordCard(
          first: index == 0,
          last: index == linked.length - 1,
          index: proxy.index,
          definition: proxy.definition,
          isSelected: proxy.selected,
          onChanged: (definition) {
            Provider.of<RecordProxyProvider>(
              context,
              listen: false,
            ).toggleSelection(definition.index);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Gap(ViewRegion.scaffoldBodyGap);
      },
      itemCount: linked.length,
    );
  }
}
