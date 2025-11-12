import 'package:fast_clipboard/model/contract/record_definition.dart';
import 'package:fast_clipboard/presenter/provider/records_provider.dart';
import 'package:fast_clipboard/view/theme/view_region.dart';
import 'package:fast_clipboard/view/widgets/content_type/file_item.dart';
import 'package:fast_clipboard/view/widgets/content_type/image_item.dart';
import 'package:fast_clipboard/view/widgets/content_type/text_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

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
      height: ViewRegion.scaffoldBodyHeight,
      width: MediaQuery.maybeWidthOf(context),
      child: Visibility(
        visible: provider.linked.isNotEmpty,
        replacement: const Center(child: Text('复制的数据将显示在这里')),
        child: ListView.separated(
          shrinkWrap: true,
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return DragItemWidget(
              dragItemProvider: (DragItemRequest p) {
                // todo
                var item = DragItem(localData: 'test');
                item.add(Formats.plainText("provider.linked[index].value"));
                return item;
              },
              allowedOperations: () =>
              [
                DropOperation.userCancelled,
                DropOperation.move,
                DropOperation.copy,
                DropOperation.link,
              ],
              canAddItemToExistingSession: true,
              child: DraggableWidget(child: _buildItem(index, provider.linked)),
            );
          },
          separatorBuilder: (context, index) {
            return Gap(ViewRegion.scaffoldBodyGap);
          },
          itemCount: provider.linked.length,
        ),
      ),
    );
  }

  Widget _buildItem(int index, List<RecordDefinition> linked) {
    if (linked[index].type == 'file') {
      return FileItem(
        no: index,
        first: index == 0,
        last: index == linked.length - 1,
        index: linked[index].idx,
        files: linked[index].files,
        length: linked[index].length,
        isSelected: linked[index].selected,
        updated: linked[index].updated,
        onChanged: (String idx) {
          Provider.of<RecordsProvider>(
            context,
            listen: false,
          ).toggleSelection(idx);
        },
      );
    }
    else if (linked[index].type == 'image') {
      return ImageItem(
        no: index,
        first: index == 0,
        last: index == linked.length - 1,
        index: linked[index].idx,
        image: linked[index].image,
        length: linked[index].length,
        isSelected: linked[index].selected,
        updated: linked[index].updated,
        onChanged: (String idx) {
          Provider.of<RecordsProvider>(
            context,
            listen: false,
          ).toggleSelection(idx);
        },
      );
    }

    return TextItem(
      no: index,
      first: index == 0,
      last: index == linked.length - 1,
      index: linked[index].idx,
      text: linked[index].text,
      length: linked[index].length,
      isSelected: linked[index].selected,
      updated: linked[index].updated,
      onChanged: (String idx) {
        Provider.of<RecordsProvider>(
          context,
          listen: false,
        ).toggleSelection(idx);
      },
    );
  }
}
