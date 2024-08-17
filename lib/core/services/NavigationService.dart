import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/StoppableService.dart';

class NavigationService extends StoppableService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  bool pop() {
    return _navigationKey.currentState.pop();
  }

  void popUntilFirstRoute() {
    _navigationKey.currentState.popUntil((route) => route.isFirst);
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToAndPop(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .popAndPushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> popAllAndNavigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  Future<dynamic> navigateToAndPopUntil(String routeName, String routeToPop) {
    return _navigationKey.currentState
        .pushNamedAndRemoveUntil(routeName, ModalRoute.withName(routeToPop));
  }

  //for starting and stopping service when app is resumed or paused
  @override
  void start() {
    super.start();
  }

  @override
  void stop() {
    super.stop();
  }
}
