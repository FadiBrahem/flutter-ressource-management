import 'package:flutter/material.dart';

class HeaderDrawer extends StatelessWidget {
  final String urlUmageUserLoggedIn;
  final String nameUserLoggedIn;
  final String roleUserLoggedIn;

  HeaderDrawer(
      {this.urlUmageUserLoggedIn,
      this.nameUserLoggedIn,
      this.roleUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(top: 50.0),
      decoration: BoxDecoration(color: Colors.white),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(urlUmageUserLoggedIn),
        ),
        title: Text(nameUserLoggedIn),
        subtitle: Text(roleUserLoggedIn),
      ),
    );
  }
}
