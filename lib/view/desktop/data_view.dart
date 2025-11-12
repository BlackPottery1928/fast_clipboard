import 'package:fast_clipboard/model/contract/record_definition.dart';
import 'package:fast_clipboard/presenter/provider/records_provider.dart';
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
    RecordsProvider provider = Provider.of<RecordsProvider>(context);
    return SizedBox(
      height: ViewRegion.scaffoldBodyHeight,
      width: MediaQuery.maybeWidthOf(context),
      child: Visibility(
        visible: provider.linked.isNotEmpty,
        replacement: DataEmpty(),
        child: _buildInfiniteScrollList(provider.linked),
      ),
    );
  }

  Widget _buildInfiniteScrollList(List<RecordDefinition> linked) {
    return ListView.separated(
      shrinkWrap: true,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        RecordDefinition definition = linked[index];
        return RecordCard(
          first: index == 0,
          last: index == linked.length - 1,
          index: definition.idx,
          definition: definition,
          isSelected: definition.selected,
          onChanged: (idx) {
            Provider.of<RecordsProvider>(
              context,
              listen: false,
            ).toggleSelection(idx.idx);
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
