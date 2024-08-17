import 'dart:collection';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ProjectService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/BaseModel.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/Kanban%20Board/Item.dart';
import 'package:enum_to_string/enum_to_string.dart';

class ViewModelKanbanBoard extends BaseModel {
  List<Item> itemsToDoList;
  List<Item> itemsDoingList;
  List<Item> itemsDoneList;

  LinkedHashMap<String, List<Item>> board;

  Future<void> fetchProjectTasks(Project project) async {
    setState(ViewState.Busy);
    itemsToDoList = List<Item>();
    itemsDoingList = List<Item>();
    itemsDoneList = List<Item>();
    _filterTasksStatus(project);

    board = LinkedHashMap();
    board.addAll({"1": itemsToDoList, "2": itemsDoingList, "3": itemsDoneList});
    /*board.addAll({
      "1": [
        Item(id: "1", listId: "1", title: "task 1"),
        Item(id: "2", listId: "1", title: "task 2"),
      ],
      "2": [
        Item(id: "3", listId: "2", title: "task 3"),
        Item(id: "4", listId: "2", title: "task 4"),
        Item(id: "5", listId: "2", title: "task 5"),
      ],
      "3": [
        Item(id: "6", listId: "3", title: "task 6"),
        Item(id: "7", listId: "3", title: "task 7"),
        Item(id: "8", listId: "3", title: "task 8"),
      ]
    });*/
    setState(ViewState.Idle);
  }

  Future<void> updateProjectTask(
      Project project, ProjectTask projectTask, String lstId) async {
    setState(ViewState.Busy);
    project.projectTasks
        .where((task) => task.id == projectTask.id)
        .forEach((task) => {
              task.title = projectTask.title,
              task.description = projectTask.description,
              task.status = lstId == "1"
                  ? EnumToString.parse(TaskStatus.ToDo)
                  : (lstId == "2"
                      ? EnumToString.parse(TaskStatus.InProgress)
                      : EnumToString.parse(TaskStatus.Done)),
              task.startDate = DateTime(projectTask.startDate.year,
                  projectTask.startDate.month, projectTask.startDate.day + 1),
              task.endDate = DateTime(projectTask.endDate.year,
                  projectTask.endDate.month, projectTask.endDate.day + 1),
              task.idResource = projectTask.idResource
            });
    await ProjectService().updateProject(project);
    setState(ViewState.Idle);
  }

  void _filterTasksStatus(Project project) {
    for (var i = 0; i < project.projectTasks.length; i++) {
      switch (project.projectTasks[i].status) {
        case "ToDo":
          {
            itemsToDoList.add(Item(
                id: i.toString(),
                listId: "1",
                projectTask: project.projectTasks[i]));
          }
          break;
        case "InProgress":
          {
            itemsDoingList.add(Item(
                id: i.toString(),
                listId: "2",
                projectTask: project.projectTasks[i]));
          }
          break;
        case "Done":
          {
            itemsDoneList.add(Item(
                id: i.toString(),
                listId: "3",
                projectTask: project.projectTasks[i]));
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
}
