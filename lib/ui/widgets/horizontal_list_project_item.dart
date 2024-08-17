import 'package:flutter/material.dart';

class HorizontalListProjectItem extends StatefulWidget {
  final String projectName;
  final Color itemColor;
  final Color itemTextColor;
  final Function onTap;

  HorizontalListProjectItem(
      {this.projectName, this.itemColor, this.onTap, this.itemTextColor});

  @override
  _HorizontalListProjectItem createState() => _HorizontalListProjectItem();
}

class _HorizontalListProjectItem extends State<HorizontalListProjectItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: 80.0,
        decoration: BoxDecoration(
          color: widget.itemColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            widget.projectName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: widget.itemTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
