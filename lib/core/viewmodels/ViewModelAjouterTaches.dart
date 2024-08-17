import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/managers/snackbar_manager.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/User.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/UserAccess.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ProjectService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ResourceService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/TachesService.dart';
import 'package:flutter/material.dart';

import 'BaseModel.dart';

class ViewModelAjouterTaches extends BaseModel {
  List<Project> projects = List<Project>();
  List<User> resources = List<User>();
  List<User> ressourcesInProject = List<User>();
  List<UserAccess> userAccessInProject = List<UserAccess>();

//Fetch list projects for horizontal listView
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
            projectResources: project.projectResources))
        .toList();

    setState(ViewState.Idle);
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

  Future<void> addTask(
      ProjectTask task, String idProject, BuildContext scaffoldContext) async {
    setState(ViewState.Busy);
    task.setDateDebut = DateTime(
        task.startDate.year, task.startDate.month, task.startDate.day + 1);
    task.setDateFin =
        DateTime(task.endDate.year, task.endDate.month, task.endDate.day + 1);
    await TachesService().insertTask(task, idProject);
    setState(ViewState.Idle);
    Scaffold.of(scaffoldContext).showSnackBar(SnackBarManager()
        .getSnackBar("Task added successfully", scaffoldContext));
  }
}
