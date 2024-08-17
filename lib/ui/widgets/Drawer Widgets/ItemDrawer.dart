import 'package:flutter/material.dart';

class ItemDrawer extends StatelessWidget {
  final String titleExpansionTile;
  final IconData iconExpansionTile;
  final List<Widget> childrenExpansionTile;

  ItemDrawer(
      {this.titleExpansionTile,
      this.iconExpansionTile,
      this.childrenExpansionTile});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        title: Row(
          children: <Widget>[
            Icon(iconExpansionTile),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(titleExpansionTile),
            ),
          ],
        ),
        children: childrenExpansionTile,
        trailing: Icon(Icons.arrow_drop_down),
      ),
    );
  }
}
