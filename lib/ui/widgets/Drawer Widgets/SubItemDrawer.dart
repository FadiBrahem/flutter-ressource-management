import 'package:flutter/material.dart';

class SubItemDrawer extends StatelessWidget {
  final IconData leadingIconSubItem;
  final String titleSubItem;
  final GestureTapCallback onTap;
  final double paddingLeftSubItem;

  SubItemDrawer(
      {this.leadingIconSubItem,
      this.onTap,
      this.titleSubItem,
      this.paddingLeftSubItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Padding(
          padding: EdgeInsets.only(left: paddingLeftSubItem),
          child: Row(
            children: <Widget>[
              Icon(leadingIconSubItem),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(titleSubItem),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
