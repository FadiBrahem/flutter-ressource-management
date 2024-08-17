import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/managers/snackbar_manager.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/User.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/UserAccess.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ProjectService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ResourceService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/BaseModel.dart';

class ViewModelUpdateProject extends BaseModel {

  List<User> resources = List<User>();
  List<UserAccess> resourcesAccess = List<UserAccess>();

  Future<void> updateProjet(Project project,BuildContext scaffoldContext) async {
    setState(ViewState.Busy);
    project.title = project.title;
    project.description = project.description;
    project.statuts = project.statuts;
    project.setDateDebut = DateTime(project.dateDebut.year,
        project.dateDebut.month, project.dateDebut.day + 1);
    project.setDateFin = DateTime(
        project.dateFin.year, project.dateFin.month, project.dateFin.day + 1);
    await ProjectService().updateProject(project);
    setState(ViewState.Idle);
    Scaffold.of(scaffoldContext).showSnackBar(SnackBarManager().getSnackBar("Project updated successfully",scaffoldContext));
  }

  Future<void> fetchAllResources() async {
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
    
    for (var i = 0; i < this.resources.length; i++) {
      final ressourceUserAccess =
          await ResourceService().getResourceRoleName(this.resources[i].id);
      this.resourcesAccess.add(UserAccess(
          services: ressourceUserAccess.services,
          roleName: ressourceUserAccess.roleName));

      setState(ViewState.Idle);
    }
  }


}
