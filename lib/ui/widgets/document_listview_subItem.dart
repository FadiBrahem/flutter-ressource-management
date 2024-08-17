import 'package:flutter/material.dart';
import 'TextFormFieldWidget.dart';


class DocumentListViewSubItem extends StatefulWidget {

  final TextEditingController textEditingController;


  DocumentListViewSubItem({this.textEditingController});
  

  @override
  _DocumentListViewSubItemState createState() => _DocumentListViewSubItemState();
}

class _DocumentListViewSubItemState extends State<DocumentListViewSubItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
          child: ListTile(
            title: TextFormFieldWidget(
              prefixIcon: Icons.event_note,
              textEditingController: widget.textEditingController,
              textAlign: TextAlign.start,
              inputBorder: InputBorder.none,
               textInputAction: TextInputAction.next,
               isEnabled: false,
            ),
          ),
        
    );
  }
}