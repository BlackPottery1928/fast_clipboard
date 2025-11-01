import 'package:flutter/material.dart';
import 'package:material_text_fields/utils/form_validation.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({super.key});

  @override
  State<StatefulWidget> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: EdgeInsetsGeometry.only(top: 10, bottom: 6),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: FormValidation.requiredTextField,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          isDense: true,
          hintText: '搜索',
          fillColor: Colors.black12,
          filled: true,
          hintStyle: TextStyle(fontSize: 14),
          contentPadding: EdgeInsets.zero,
          suffixIcon: IconButton(icon: Icon(Icons.close), onPressed: () {}),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
