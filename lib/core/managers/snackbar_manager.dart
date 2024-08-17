import 'package:flutter/material.dart';

class SnackBarManager {
  SnackBar getSnackBar(String content,BuildContext context) {
    return SnackBar(
      content: Text(
        content,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      action: SnackBarAction(
        label: "Hide",
        textColor: Colors.white,
        disabledTextColor: Colors.black,
        onPressed: () =>Scaffold.of(context).hideCurrentSnackBar(),
      ),
      backgroundColor: Colors.blue,
    );
  }
}
