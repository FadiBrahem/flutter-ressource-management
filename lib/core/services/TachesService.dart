import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:naxxum_projectplanner_mobile_local/core/constants/uri_constants.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';

import 'StoppableService.dart';

class TachesService extends StoppableService{
  Future<void> insertTask(ProjectTask task, String idProject) async {
    try {
      final response = await http.post("$insertTacheURI/$idProject",
          headers: {"Content-Type": "application/json"},
          body: json.encode(task.toJson()));
      if (response.statusCode == 200) {
        print("Task added succefully");
      }
    } catch (err) {
      print("=========>" + err.toString());
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
