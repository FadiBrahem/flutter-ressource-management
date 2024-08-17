import 'package:flutter/material.dart';

class TaskListViewItem extends StatefulWidget {
  final String taskTitle;
  final Function onLongPress;
  final Function onTap;

  TaskListViewItem({@required this.taskTitle, this.onLongPress, this.onTap});

  @override
  _TaskListViewItemState createState() => _TaskListViewItemState();
}

class _TaskListViewItemState extends State<TaskListViewItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Container(
          child: ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text(widget.taskTitle),
          ),
        ),
      ),
    );
  }
}
