import 'package:flutter/material.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({super.key});

  @override
  State<StatefulWidget> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      margin: EdgeInsetsGeometry.only(top: 10, bottom: 6),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        toolbarOptions: ToolbarOptions(selectAll: true, paste: true),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black26),
          prefixIconConstraints: BoxConstraints(minWidth: 32),
          isDense: true,
          hintText: '搜索',
          fillColor: Colors.black12,
          filled: true,
          hintStyle: TextStyle(fontSize: 14),
          contentPadding: EdgeInsets.zero,
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {},
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            color: Colors.black26,
          ),
          constraints: BoxConstraints(maxHeight: 32),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
