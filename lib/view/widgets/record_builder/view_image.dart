import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget {
  final String index;
  final Uint8List? image;

  const ViewImage({super.key, required this.index, required this.image});

  @override
  State<StatefulWidget> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return PhotoView(imageProvider: MemoryImage(widget.image!, scale: 1.0));
  }
}
