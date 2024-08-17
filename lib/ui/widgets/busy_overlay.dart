import 'package:flutter/material.dart';

class BusyOverlay extends StatelessWidget {
  final Widget child;
  final String title;
  final bool show;
  final bool isDisabled;

  const BusyOverlay(
      {this.child, this.title = 'Please wait...', this.show = false,this.isDisabled});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Material(
        child: Stack(children: <Widget>[
      IgnorePointer(
        ignoring: isDisabled,
        child: child,
      ),
      IgnorePointer(
        child: Opacity(
            opacity: show ? 1.0 : 0.0,
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              alignment: Alignment.center,
              color: Color.fromARGB(100, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(title,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan)),
                ],
              ),
            )),
      ),
    ]));
  }
}
