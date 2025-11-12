import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ViewFile extends StatefulWidget {
  final String index;
  final List<String> files;

  const ViewFile({super.key, required this.index, required this.files});

  @override
  State<StatefulWidget> createState() => _ViewFileState();
}

class _ViewFileState extends State<ViewFile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              'assets/file.svg',
              fit: BoxFit.contain,
              width: 160,
              height: 160,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SelectableText(
              widget.files.first,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
