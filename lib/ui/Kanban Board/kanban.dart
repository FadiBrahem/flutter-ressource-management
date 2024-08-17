import 'dart:collection';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/Kanban%20Board/Item.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelKanbanBoard.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Kanban extends StatefulWidget {
  final double tileHeight = 100;
  final double headerHeight = 80;
  //final double tileWidth = 200;

  final Map<String, dynamic> args;

  Kanban({@required this.args});

  @override
  _KanbanState createState() => _KanbanState();
}

class _KanbanState extends State<Kanban> {
  //Project Fields
  Project _project;

  @override
  void initState() {
    _project = widget.args["project"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return ViewModelProvider<ViewModelKanbanBoard>.withConsumer(
      viewModel: ViewModelKanbanBoard(),
      onModelReady: (model) => model.fetchProjectTasks(_project),
      builder: (context, model, child) => Scaffold(
        //drawer: AppDrawer(),
        backgroundColor: Color.fromARGB(240, 248, 255, 255),
        /*appBar: AppBar(
          title: Text("Ressource Management"),
        ),*/
        body: BusyOverlay(
            show: model.state == ViewState.Busy,
            isDisabled: model.state == ViewState.Busy ? true : false,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: model.board.keys.map((String key) {
                    return Container(
                      width: screenWidth(context) / 3,
                      child: buildKanbanList(
                          key, model.board[key], model.board, model, _project),
                    );
                  }).toList()),
            )),
      ),
    );
  }

  buildKanbanList(String listId, List<Item> items, LinkedHashMap board,
      ViewModelKanbanBoard viewModelKanbanBoard, Project project) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          buildHeader(listId, board, viewModelKanbanBoard, project),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  Draggable<Item>(
                    data: items[index],
                    child: ItemWidget(
                      item: items[index],
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.2,
                      child: ItemWidget(item: items[index]),
                    ),
                    feedback: Container(
                      height: widget.tileHeight,
                      width: screenWidth(context) / 3,
                      child: FloatingWidget(
                          child: ItemWidget(
                        item: items[index],
                      )),
                    ),
                  ),
                  buildItemDragTarget(listId, index, widget.tileHeight, board,
                      viewModelKanbanBoard, project),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  buildItemDragTarget(
      listId,
      targetPosition,
      double height,
      LinkedHashMap board,
      ViewModelKanbanBoard viewModelKanbanBoard,
      Project project) {
    return DragTarget<Item>(
      onWillAccept: (Item data) {
        return board[listId].isEmpty ||
            data.id != board[listId][targetPosition].id;
      },
      onAccept: (Item data) async {
        setState(() {
          board[data.listId].remove(data);
          data.listId = listId;
          if (board[listId].length > targetPosition) {
            board[listId].insert(targetPosition + 1);
          } else {
            board[listId].add(data);
          }
        });
        viewModelKanbanBoard.updateProjectTask(
            project, data.projectTask, data.listId);
      },
      builder:
          (BuildContext context, List<Item> data, List<dynamic> rejectedData) {
        if (data.isEmpty) {
          return Container(
            height: height,
          );
        } else {
          return Column(
            children: [
              Container(
                height: height,
              ),
              ...data.map((Item item) {
                return Opacity(
                  opacity: 0.5,
                  child: ItemWidget(item: item),
                );
              }).toList()
            ],
          );
        }
      },
    );
  }

  buildHeader(String listId, LinkedHashMap board,
      ViewModelKanbanBoard viewModelKanbanBoard, Project project) {
    Widget header = Container(
      height: widget.headerHeight,
      child: HeaderWidget(
          title: listId == "1" ? "ToDo" : (listId == "2" ? "Doing" : "Done")),
    );

    return Stack(
      // The header
      children: [
        Draggable<String>(
          data: listId == "1" ? "ToDo" : (listId == "2" ? "Doing" : "Done"),
          child: header,
          childWhenDragging: Opacity(
            opacity: 0.2,
            child: header,
          ),
          feedback: FloatingWidget(
            child: Container(
              width: screenWidth(context) / 3,
              child: header,
            ),
          ),
        ),
        buildItemDragTarget(listId, 0, widget.headerHeight, board,
            viewModelKanbanBoard, project),
        DragTarget<String>(
          onWillAccept: (String incomingListId) {
            return listId != incomingListId;
          },
          onAccept: (String incomingListId) {
            setState(
              () {
                LinkedHashMap<String, List<Item>> reorderedBoard =
                    LinkedHashMap();
                for (String key in board.keys) {
                  if (key == incomingListId) {
                    reorderedBoard[listId] = board[listId];
                  } else if (key == listId) {
                    reorderedBoard[incomingListId] = board[incomingListId];
                  } else {
                    reorderedBoard[key] = board[key];
                  }
                }
                board = reorderedBoard;
              },
            );
          },
          builder: (BuildContext context, List<String> data,
              List<dynamic> rejectedData) {
            if (data.isEmpty) {
              return Container(
                height: widget.headerHeight,
                width: screenWidth(context) / 3,
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.blueAccent,
                  ),
                ),
                height: widget.headerHeight,
                width: screenWidth(context) / 3,
              );
            }
          },
        )
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String title;

  const HeaderWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final Item item;

  const ItemWidget({Key key, this.item}) : super(key: key);
  ListTile makeListTile(Item item) => ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        title: Text(
          item.projectTask.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(item.projectTask.getStatuts.toString()),
        onTap: () {},
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(64, 75, 96, .9),
        ),
        child: makeListTile(item),
      ),
    );
  }
}

class FloatingWidget extends StatelessWidget {
  final Widget child;

  const FloatingWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.1,
      child: child,
    );
  }
}

String updatestatus(String listId) {
  switch (listId) {
    case "1":
      return EnumToString.parse(TaskStatus.ToDo);
    case "2":
      return EnumToString.parse(TaskStatus.InProgress);
    case "3":
      return EnumToString.parse(TaskStatus.Done);
    default:
      return "Eror converting status";
  }
}
