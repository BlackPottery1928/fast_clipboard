import 'package:fast_clipboard/presenter/provider/records_provider.dart';
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
      height: 330,
      width: MediaQuery.of(context).size.width,
      child: Visibility(
        visible: provider.linked.isNotEmpty,
        replacement: const Center(child: Text('复制的数据将显示在这里')),
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return DragItemWidget(
              dragItemProvider: (DragItemRequest p) {},
              allowedOperations: () => [
                DropOperation.move,
                DropOperation.copy,
                DropOperation.userCancelled,
              ],
              canAddItemToExistingSession: true,
              liftBuilder: (context, child) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                  child: child,
                );
              },
              dragBuilder: (BuildContext context, Widget child) {
                return SnapshotSettings(
                  translation: (rect, dragPosition) => const Offset(-2, -2),
                  constraintsTransform: (constraints) =>
                      constraints.deflate(const EdgeInsets.all(-2)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    padding: const EdgeInsets.all(1),
                    child: child,
                  ),
                );
              },
              child: DraggableWidget(
                child: TextItem(
                  no: index,
                  index: provider.linked[index].idx,
                  text: provider.linked[index].value,
                  length: provider.linked[index].length,
                  isSelected: provider.linked[index].selected,
                  updated: provider.linked[index].updated,
                  onChanged: (String idx) {
                    Provider.of<RecordsProvider>(
                      context,
                      listen: false,
                    ).toggleSelection(idx);
                  },
                ),
              ),
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
