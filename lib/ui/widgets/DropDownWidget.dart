import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  final String selectedItem;
  final List<String> itemsToBeSelected;
  final ValueChanged<String> onChanged;

  DropDownWidget(
      {@required this.selectedItem,
      @required this.itemsToBeSelected,
      @required this.onChanged});

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
 
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedItem,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: widget.onChanged,
      items: widget.itemsToBeSelected
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
