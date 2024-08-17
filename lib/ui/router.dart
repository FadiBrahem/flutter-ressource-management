import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/constants/routing_constants.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/Kanban%20Board/kanban.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/Consulter_Taches_View.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/ajouter_document_view.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/ajouter_projet_view.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/ajouter_taches_view.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/consulter_projet_view.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/home_view.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/project_details_view.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/reporting_view.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/settings_view.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/views/task_details_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      return MaterialPageRoute(builder: (context) => HomeView());
    case ajouterProjetRoute:
      return MaterialPageRoute(builder: (context) => AjouterProjetView());
    case consulterProjetRoute:
      return MaterialPageRoute(builder: (context) => ConsulterProjetView());
    case projectDetailsRoute:
      return MaterialPageRoute(
          builder: (context) =>
              ProjectDetailsView(project: settings.arguments));
    case ajouterTacheRoute:
      return MaterialPageRoute(
        builder: (context) => AjouterTachesView(),
      );
    case consulterTachesRoute:
      return MaterialPageRoute(
        builder: (context) => ConsulterTachesView(),
      );
    case taskDetailsRoute:
      return MaterialPageRoute(
        builder: (context) => TaskDetailsView(
          args: settings.arguments,
        ),
      );
    case settingsRoute:
      return MaterialPageRoute(
        builder: (context) => SettingsView(),
      );
    case ajouterDocumentRoute:
      return MaterialPageRoute(
        builder: (context) => AjouterDocumentView(),
      );
    case kanbanBoardRoute:
      return MaterialPageRoute(
        builder: (context) => Kanban(
          args: settings.arguments,
        ),
      );
    case reportingRoute:
      return MaterialPageRoute(
        builder: (context) => ReportingView(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}
