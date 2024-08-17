import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/constants/uri_constants.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/managers/snackbar_manager.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/User.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/UserAccess.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ProjectService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ResourceService.dart';
import 'BaseModel.dart';

class ViewModelAjouterProjet extends BaseModel {
  List<User> resources = List<User>();
  List<UserAccess> userAccess = List<UserAccess>();


  Future<void> ajouterProjet(Project projet, BuildContext context) async {
    setState(ViewState.Busy);
    projet.setDateDebut = DateTime(projet.dateDebut.year,
        projet.dateDebut.month, projet.dateDebut.day + 1);
    projet.setDateFin = DateTime(
        projet.dateFin.year, projet.dateFin.month, projet.dateFin.day + 1);
    projet.setIdEntreprise = idEntreprise;
    await ProjectService().insertProject(projet);
    setState(ViewState.Idle);
    Scaffold.of(context).showSnackBar(
        SnackBarManager().getSnackBar("Project added successfully", context));
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
      this.userAccess.add(UserAccess(
          services: ressourceUserAccess.services,
          roleName: ressourceUserAccess.roleName));

     
      setState(ViewState.Idle);
    }
  }

 
}
 




