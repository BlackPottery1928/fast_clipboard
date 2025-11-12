import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DragWidget extends StatefulWidget {
  final Widget child;

  const DragWidget({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      dragItemProvider: (DragItemRequest p) {
        // todo
        var item = DragItem(localData: 'test');
        item.add(Formats.plainText("provider.linked[index].value"));
        return item;
      },
      allowedOperations: () => [
        DropOperation.userCancelled,
        DropOperation.move,
        DropOperation.copy,
        DropOperation.link,
      ],
      canAddItemToExistingSession: true,
      child: DraggableWidget(child: widget.child),
    );
  }
}
