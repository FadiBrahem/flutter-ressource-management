import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ressource Management"),
          backgroundColor: Colors.blue,
        ),
        body: Center(child: Text("home")),
        drawer: AppDrawer(),
      ),
    );
  }
}
