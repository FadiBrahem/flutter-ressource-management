import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/DialogService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/NavigationService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ProjectService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/StoppableService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/TachesService.dart';
import 'package:naxxum_projectplanner_mobile_local/locator.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key key, this.child}) : super(key: key);

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  List<StoppableService> _serviceToManage = [
    locator<ProjectService>(),
    locator<TachesService>(),
    locator<DialogService>(),
    locator<NavigationService>(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _serviceToManage.forEach((service) {
      if (state == AppLifecycleState.resumed) {
        service.start();
      } else {
        service.stop();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
