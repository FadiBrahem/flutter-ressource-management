import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/constants/routing_constants.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/managers/snackbar_manager.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/DialogService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/NavigationService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ProjectService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/BaseModel.dart';
import '../../locator.dart';

class ViewModelConsulterTaches extends BaseModel {
  //Service injection
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();

  //Project List Fields
  List<Project> projects = List<Project>();

  //Tab Bar Tasks
  List<ProjectTask> toDoList;
  List<ProjectTask> doingList;
  List<ProjectTask> doneList;

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

  Future<void> fetchProjectTasks(String idProject) async {
    setState(ViewState.Busy);
    Project project = await ProjectService().fetchProjectById(idProject);
    toDoList = List<ProjectTask>();
    doingList = List<ProjectTask>();
    doneList = List<ProjectTask>();
    _filterTasksStatus(project);
    setState(ViewState.Idle);
  }

  Future<void> deleteTask(Project project, ProjectTask projectTask,
      BuildContext scaffoldContext) async {
    var dialogResult = await _dialogService.showDialog(
      title: "Delete",
      description: "Voulez vous vraiment supprimer la tache",
      buttonTitle: "DELETE",
    );
    if (dialogResult.confirmed) {
      setState(ViewState.Busy);
      project.projectTasks.removeWhere((task) => task.id == projectTask.id);
      await ProjectService().updateProject(project);
      _updateDisplayedTasksList(projectTask);
      setState(ViewState.Idle);
      Scaffold.of(scaffoldContext).showSnackBar(SnackBarManager()
          .getSnackBar("Task deleted successfully", scaffoldContext));
    }
  }

  //Navigate to update Task view with passing project
  void navigateToUpdateView(ProjectTask projectTask, Project project) {
    _navigationService.navigateTo(taskDetailsRoute,
        arguments: <String, dynamic>{"project": project, "task": projectTask});
  }

  //Navigate to Kanban board with passing project
  void navigateToKanbanBoard(Project project) {
    _navigationService.navigateTo(kanbanBoardRoute,
        arguments: <String, dynamic>{"project": project});
  }

  void _filterTasksStatus(Project project) {
    for (var i = 0; i < project.projectTasks.length; i++) {
      switch (project.projectTasks[i].status) {
        case "ToDo":
          {
            toDoList.add(project.projectTasks[i]);
          }
          break;
        case "InProgress":
          {
            doingList.add(project.projectTasks[i]);
          }
          break;
        case "Done":
          {
            doneList.add(project.projectTasks[i]);
          }
          break;
        default:
          {
            print("wrong status");
          }
          break;
      }
    }
  }

  void _updateDisplayedTasksList(ProjectTask projectTask) {
    switch (projectTask.status) {
      case "ToDo":
        {
          toDoList.removeWhere((task) => task.id == projectTask.id);
        }
        break;
      case "InProgress":
        {
          doingList.removeWhere((task) => task.id == projectTask.id);
        }
        break;
      case "Done":
        {
          doneList.removeWhere((task) => task.id == projectTask.id);
        }
        break;
      default:
        {
          print("wrong status");
        }
        break;
    }
  }
}
