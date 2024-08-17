import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';

class DocumentListViewItem extends StatelessWidget {
  
  final String titleFile;
  final Widget fileNotesWidget;

  DocumentListViewItem({this.titleFile,this.fileNotesWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        leading: Icon(Icons.insert_drive_file),
        title: Row(
          children: <Widget>[
            Text(titleFile),
          ],
        ),
        children: <Widget>[fileNotesWidget],
        trailing: Icon(Icons.arrow_drop_down),
      ),
    );
  }
}