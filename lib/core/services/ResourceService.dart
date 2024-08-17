
import 'package:naxxum_projectplanner_mobile_local/core/constants/uri_constants.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectRessources.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/User.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/UserAccess.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/StoppableService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class ResourceService extends StoppableService{

Future<List<User>> fetchActifEntrepriseResources() async {
    final response = await http.get(getAllEntrepriseResourceURI+idEntreprise);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception("Error getting all Entreprise Resources");
    }
  }

  //get the role name of resource
  Future<UserAccess> getResourceRoleName(String idResource) async {
    final response = await http.get(getRessourceRoleNameURI+idEntreprise+"/getUserAcces/$idResource");
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return UserAccess.fromJson(body);
    } else {
      throw Exception("Error getting all Ressource Name");
    }
  }

  //insert project Resource
  /* Future<void> insertProjectResource(ProjectResources projectResources, String idProject) async {
    try {
      final response = await http.post("$insertProjectRessourceURI/$idProject",
          headers: {"Content-Type": "application/json"},
          body: json.encode(projectResources.toJson()));
      if (response.statusCode == 200) {
        print("Project Ressource added succefully");
      }
    } catch (err) {
      print("=========>" + err.toString());
    }
  }*/

}