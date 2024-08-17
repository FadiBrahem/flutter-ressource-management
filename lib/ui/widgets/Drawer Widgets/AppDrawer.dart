import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelNavigationDrawer.dart';
import 'HeaderDrawer.dart';
import 'ItemDrawer.dart';
import 'SubItemDrawer.dart';
import 'package:provider_architecture/provider_architecture.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ViewModelNavigationDrawer>.withConsumer(
      viewModel: ViewModelNavigationDrawer(),
      builder: (context, model, child) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            HeaderDrawer(
              nameUserLoggedIn: "Habib Hentati",
              urlUmageUserLoggedIn: "url",
              roleUserLoggedIn: "Chef de Projet",
            ),
            ItemDrawer(
              iconExpansionTile: Icons.folder_open,
              titleExpansionTile: "Gerer Projets",
              childrenExpansionTile: <Widget>[
                SubItemDrawer(
                  paddingLeftSubItem: 30.0,
                  leadingIconSubItem: Icons.add,
                  titleSubItem: "Ajouter Projet",
                  onTap: () => model.navigateToAddProject(),
                ),
                SubItemDrawer(
                  paddingLeftSubItem: 30.0,
                  leadingIconSubItem: Icons.view_array,
                  titleSubItem: "Consulter projets",
                  onTap: () => model.navigateToConsulterProjets(),
                ),
              ],
            ),
            ItemDrawer(
              iconExpansionTile: Icons.folder_special,
              titleExpansionTile: "Gerer Taches",
              childrenExpansionTile: <Widget>[
                SubItemDrawer(
                  paddingLeftSubItem: 30.0,
                  leadingIconSubItem: Icons.add,
                  titleSubItem: "Ajouter Taches",
                  onTap: () => model.navigateToAddTache(),
                ),
                SubItemDrawer(
                  paddingLeftSubItem: 30.0,
                  leadingIconSubItem: Icons.view_array,
                  titleSubItem: "Consulter Taches",
                  onTap: () => model.navigateToConsulterTaches(),
                ),
              ],
            ),
            ItemDrawer(
              iconExpansionTile: Icons.schedule,
              titleExpansionTile: "Plannifier Ressources",
              childrenExpansionTile: <Widget>[
                SubItemDrawer(
                  paddingLeftSubItem: 30.0,
                  leadingIconSubItem: Icons.add,
                  titleSubItem: "Ajouter des Ressources",
                  onTap: () {},
                ),
                SubItemDrawer(
                  paddingLeftSubItem: 30.0,
                  leadingIconSubItem: Icons.view_array,
                  titleSubItem: "Consulter les Ressources",
                  onTap: () {},
                ),
              ],
            ),
            ItemDrawer(
              iconExpansionTile: Icons.pie_chart,
              titleExpansionTile: "Reports",
              childrenExpansionTile: <Widget>[
                SubItemDrawer(
                  paddingLeftSubItem: 30.0,
                  leadingIconSubItem: Icons.view_array,
                  titleSubItem: "Consulter Les Rapports",
                  onTap: () => model.navigateToReporting(),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 90.0)),
            Divider(),
            SubItemDrawer(
              paddingLeftSubItem: 0.0,
              leadingIconSubItem: Icons.settings_applications,
              titleSubItem: "Paramétres",
              onTap: () => model.navigateToSettings(),
            ),
            SubItemDrawer(
              paddingLeftSubItem: 0.0,
              leadingIconSubItem: Icons.launch,
              titleSubItem: "Log Out",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
