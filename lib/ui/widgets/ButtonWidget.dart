import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final String text;

  ButtonWidget({@required this.onPressed, @required this.text});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 40,
      buttonColor: Colors.blue.withOpacity(0.4),
      minWidth: 150.0,
      child: RaisedButton(
        child: Text(text),
        onPressed: this.onPressed,
      ),
    );
  }
}
