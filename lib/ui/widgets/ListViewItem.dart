import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';

class ListViewItem extends StatelessWidget {
  final Project project;
  final Function onLongPress;
  final Function onTap;

  ListViewItem({this.project, this.onLongPress, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(64, 75, 96, .9).withOpacity(0.8),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: const EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24),
                ),
              ),
              child: Icon(
                Icons.folder_open,
                color: Colors.white,
              ),
            ),
            title: Text(
              project.title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(project.statuts,
                style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Colors.white, size: 30.0),
          ),
        ),
      ),
    );
  }
}
