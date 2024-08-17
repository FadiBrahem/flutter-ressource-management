import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/Charts%20Models/RessourceProjectProgress.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/Charts%20Models/Task.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/User.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ProjectService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ResourceService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/BaseModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ViewModelReporting extends BaseModel {
  List<Project> projects = List<Project>();

  //1st Tab Reporting Fields
  List<ProjectTask> totalTasks;
  List<ProjectTask> todayTasks;
  List<ProjectTask> lateTasks;
  List<ProjectTask> completedTasks;
  int totalTasksHours, todayTasksHours, lateTasksHours, completedTasksHours;

  //2nd Tab Pie Chart Fields
  List<User> resources = List<User>();
  List<User> ressourcesInProject = List<User>();
  List<charts.Series<Task, String>> risksPieChart;

  //3rd Tab Bar Chart
  List<charts.Series<RessourceProjectProgress, String>> ressTasksProgress;

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

  Future<void> generalReportsByProject(String idProject) async {
    setState(ViewState.Busy);

    Project project = await ProjectService().fetchProjectById(idProject);
    totalTasks = List<ProjectTask>();
    todayTasks = List<ProjectTask>();
    lateTasks = List<ProjectTask>();
    completedTasks = List<ProjectTask>();
    DateTime currentSystemDate = DateTime.now();
    totalTasks = project.projectTasks;
    todayTasks = project.projectTasks
        .where((projectTask) => projectTask.status == "ToDo")
        .toList();
    lateTasks = project.projectTasks
        .where((projectTask) =>
            projectTask.endDate.difference(currentSystemDate).inDays > 0 &&
            projectTask.status != "Done")
        .toList();
    completedTasks = project.projectTasks
        .where((projectTask) => projectTask.status == "Done")
        .toList();
    totalTasksHours = _numeberOfHours(totalTasks);
    todayTasksHours = _numeberOfHours(todayTasks);
    lateTasksHours = _numeberOfHours(lateTasks);
    completedTasksHours = _numeberOfHours(completedTasks);

    //Fill Data In PieChart
    risksPieChart = List<charts.Series<Task, String>>();
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

    _buildRisksPieChart(
        risksPieChart, this.ressourcesInProject, this.lateTasks);

    //Fill Data In Bar Chart
    ressTasksProgress = List<charts.Series<RessourceProjectProgress, String>>();
    _buildRessTasksProgress(
        ressTasksProgress, this.totalTasks, this.ressourcesInProject);

    setState(ViewState.Idle);
  }

  int _numeberOfHours(List<ProjectTask> lst) {
    int total = 0;
    for (var i = 0; i < lst.length; i++) {
      total = total + lst[i].endDate.difference(lst[i].startDate).inDays * 8;
    }
    return total;
  }

  int _nbLateTasksPerUser(User ress, List<ProjectTask> lateTasks) {
    var cpt = 0;
    for (var i = 0; i < lateTasks.length; i++) {
      if (lateTasks[i].idResource == ress.id) {
        cpt++;
      }
    }
    return cpt;
  }

  void _buildRisksPieChart(List<charts.Series<Task, String>> seriesPieData,
      List<User> lstRess, List<ProjectTask> lateTasks) {
    var pieChartData = List<Task>();
    for (var i = 0; i < lstRess.length; i++) {
      if (_nbLateTasksPerUser(lstRess[i], lateTasks) == 0) {
        pieChartData.add(Task(
            lstRess[i].name + " " + lstRess[i].lastName, 0, Color(0xff3366cc)));
      } else {
        pieChartData.add(Task(
            (lstRess[i].name + " " + lstRess[i].lastName),
            (_nbLateTasksPerUser(lstRess[i], lateTasks) * 100) /
                lateTasks.length,
            Color(0xff3366cc)));
      }
    }

    seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'testchart1',
        data: pieChartData,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  List<ProjectTask> _getRessTasksPerProject(
      List<ProjectTask> allTasks, User ress) {
    List<ProjectTask> lstFinal = List<ProjectTask>();
    for (var i = 0; i < allTasks.length; i++) {
      if (allTasks[i].idResource == ress.id) {
        lstFinal.add(allTasks[i]);
      }
    }
    return lstFinal;
  }

  int _calculateProgressRess(List<ProjectTask> ressTasks) {
    var cpt = 0;
    for (var i = 0; i < ressTasks.length; i++) {
      if (ressTasks[i].status == "Done") {
        cpt++;
      }
    }
    return cpt;
  }

  void _buildRessTasksProgress(
      List<charts.Series<RessourceProjectProgress, String>> _seriesData,
      List<ProjectTask> totalTasksList,
      List<User> lstRess) {
    {
      var barData = List<RessourceProjectProgress>();
      for (var i = 0; i < lstRess.length; i++) {
        var ressTasks = _getRessTasksPerProject(totalTasksList, lstRess[i]);
        barData.add(RessourceProjectProgress(
            lstRess[i].name,
            ((_calculateProgressRess(ressTasks) * 100) / ressTasks.length)
                .round()));
      }

      _seriesData.add(new charts.Series<RessourceProjectProgress, String>(
        id: 'Ressource Tasks Progress',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (RessourceProjectProgress ressourceProjectProgress, _) =>
            ressourceProjectProgress.ressourceName,
        measureFn: (RessourceProjectProgress ressourceProjectProgress, _) =>
            ressourceProjectProgress.progress,
        data: barData,
      ));
    }
  }
}
