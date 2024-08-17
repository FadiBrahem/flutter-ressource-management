import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:naxxum_projectplanner_mobile_local/core/constants/uri_constants.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/StoppableService.dart';

class ProjectService extends StoppableService{
   
  
  Future<List<Project>> fetchAllProjects(String keyword) async {
    final response = await http.get(getAllProjectsURI+idEntreprise+"?keyword="+keyword);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((project) => Project.fromJson(project)).toList();
    } else {
      throw Exception("Error getting all projects");
    }
  }
  

  Future<Project> fetchProjectById(String idProject) async {
    final response = await http.get("$getProjectByIdURI/$idProject");
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Project.fromJson(body);
    } else {
      throw Exception("Error getting all projects");
    }
  }

  Future<Project> insertProject(Project project) async {
    final response = await http.post(insertProjectURI,
        headers: {"Content-Type": "application/json"},
        body: json.encode(project.toJson()));
    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load inserted project");
    }
  }

  Future<http.Response> deleteProject(String id) async {
    final http.Response response = await http.delete(
      deleteProjectURI + "$id",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw ("Failed to delete Project");
    }
  }

  Future<Project> updateProject(Project project) async {
    final response = await http.put(
      updateProjectURI + project.id,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(project.toJson()),
    );
    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load updated project");
    }
  }


  //for starting and stopping service when app is resumed or paused
  @override
  void start(){
    super.start();
  }

  @override
  void stop(){
    super.stop();
  }
}
