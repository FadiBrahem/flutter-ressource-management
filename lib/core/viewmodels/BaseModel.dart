import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
