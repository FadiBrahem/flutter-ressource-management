import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/constants/routing_constants.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/managers/snackbar_manager.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/User.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/UserAccess.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/NavigationService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ProjectService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ResourceService.dart';
import 'package:naxxum_projectplanner_mobile_local/locator.dart';

import 'BaseModel.dart';

class ViewModelUpdateTasks extends BaseModel {
  final _navigationService = locator<NavigationService>();
  List<User> resources = List<User>();
  List<User> ressourcesInProject = List<User>();
  List<UserAccess> userAccessInProject = List<UserAccess>();

  Future<void> updateProjectTask(Project project, ProjectTask projectTask,
      BuildContext scaffoldContext) async {
    setState(ViewState.Busy);
    project.projectTasks
        .where((task) => task.id == projectTask.id)
        .forEach((task) => {
              task.title = projectTask.title,
              task.description = projectTask.description,
              task.status = projectTask.status,
              task.startDate = DateTime(projectTask.startDate.year,
                  projectTask.startDate.month, projectTask.startDate.day + 1),
              task.endDate = DateTime(projectTask.endDate.year,
                  projectTask.endDate.month, projectTask.endDate.day + 1),
              task.idResource = projectTask.idResource
            });
    await ProjectService().updateProject(project);
    setState(ViewState.Idle);
    Scaffold.of(scaffoldContext).showSnackBar(SnackBarManager()
        .getSnackBar("Task updated successfully", scaffoldContext));
  }

  //Navigate to update Task view with passing project
  void navigateToAddDocumentView() {
    _navigationService.navigateTo(ajouterDocumentRoute);
  }

  Future<void> fetchAllRessourcesProject(Project project) async {
    setState(ViewState.Busy);
    final results = await ResourceService().fetchActifEntrepriseResources();
    this.resources = results
        .map((user) => User(
            id: user.id,
            name: user.name,
            lastName: user.lastName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            roleId: user.roleId))
        .toList();

    //Afficher seulement les ressources d'une tache d'un projet spécifique
    for (var i = 0; i < project.getProjectRessources.length; i++) {
      var cpt = 0;
      while (cpt < this.resources.length) {
        if (this.resources[cpt].getId ==
            project.getProjectRessources[i].getIdResource) {
          this.ressourcesInProject.add(this.resources[cpt]);
        }
        cpt++;
      }
    }

    for (var i = 0; i < this.ressourcesInProject.length; i++) {
      final ressourceUserAccess =
          await ResourceService().getResourceRoleName(this.resources[i].id);
      this.userAccessInProject.add(UserAccess(
          services: ressourceUserAccess.services,
          roleName: ressourceUserAccess.roleName));
    }

    setState(ViewState.Idle);
  }
}
