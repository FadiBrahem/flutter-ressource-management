import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/constants/routing_constants.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/managers/snackbar_manager.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/DialogService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/NavigationService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ProjectService.dart';
import 'package:naxxum_projectplanner_mobile_local/locator.dart';
import 'BaseModel.dart';

class ViewModelConsulterProjet extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<Project> projects = List<Project>();

  Future<void> fetchAllProjects(String keyword) async {
    setState(ViewState.Busy);

    final results = await ProjectService().fetchAllProjects(keyword);
    this.projects = results
        .map((project) => Project(
            id: project.id,
            title: project.title,
            description: project.description,
            dateDebut: project.dateDebut,
            dateFin: project.dateFin,
            statuts: project.statuts,
            idEntreprise: project.idEntreprise,
            projectTasks: project.projectTasks,
            projectResources: project.projectResources,
            ))
        .toList();

    setState(ViewState.Idle);
  }

  //Delete Project
  Future supprimerProjet(Project project,BuildContext scaffoldContext) async {
    var dialogResult = await _dialogService.showDialog(
      title: "Delete",
      description: "Voulez vous vraiment supprimer " + project.title,
      buttonTitle: "DELETE",
    );

    if (dialogResult.confirmed) {
      setState(ViewState.Busy);
      await ProjectService().deleteProject(project.id);
      projects.removeWhere((p) => p.id == project.id);
      setState(ViewState.Idle);
      Scaffold.of(scaffoldContext).showSnackBar(SnackBarManager().getSnackBar("Project deleted successfully",scaffoldContext));
    }
  }

  //Navigate to update view with passing project
  void navigateToUpdateView(Project project) {
    _navigationService.navigateTo(projectDetailsRoute, arguments: project);
  }
}
