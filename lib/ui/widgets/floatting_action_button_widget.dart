import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:naxxum_projectplanner_mobile_local/ui/shared/shared_styles.dart';

class FloatingActionButtonWidget extends StatefulWidget {

  final Function onTapUpdateTask;
  final Function onTapAddDocument;

  FloatingActionButtonWidget({this.onTapUpdateTask,this.onTapAddDocument});
  

  @override
  _FloatingActionButtonWidgetState createState() => _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState extends State<FloatingActionButtonWidget> with TickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
     _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(
                  0.0,
                  1.0 - 0.0 / 2.0 / 2.0,
                  curve: Curves.easeOut
                ),
              ),
              child: new FloatingActionButton(
                heroTag: null,
                backgroundColor: backgroundColor(context),
                mini: true,
                child: new Icon(Icons.note_add, color: foregroundColor(context)),
                onPressed: widget.onTapAddDocument,
              ),
            ),
          ),
          new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(
                  0.0,
                  1.0 - 1.0 / 2.0 / 2.0,
                  curve: Curves.easeOut
                ),
              ),
              child: new FloatingActionButton(
                
                heroTag: null,
                backgroundColor: backgroundColor(context),
                mini: true,
                child: new Icon(Icons.update, color: foregroundColor(context)),
                onPressed: widget.onTapUpdateTask,
              ),
            ),
          ),
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(_controller.isDismissed ? Icons.share : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ],
      );
  }
}