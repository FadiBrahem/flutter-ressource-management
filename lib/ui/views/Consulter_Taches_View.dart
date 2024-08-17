import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelConsulterTaches.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextFormFieldWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/horizontal_list_project_item.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/task_listview_item.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ConsulterTachesView extends StatefulWidget {
  @override
  _ConsulterTachesViewState createState() => _ConsulterTachesViewState();
}

class _ConsulterTachesViewState extends State<ConsulterTachesView>
    with SingleTickerProviderStateMixin {
  //Tab Controller Fields
  final List<Widget> myTabs = [
    Tab(text: 'To Do'),
    Tab(text: 'Doing'),
    Tab(text: 'Done'),
  ];
  TabController _tabController;

  //FormFields
  TextEditingController _ecSearchProject;
  FocusNode _searchFocusNode;
  int _selectedProjectIndex;

  @override
  void initState() {
    super.initState();
    _ecSearchProject = TextEditingController();
    _searchFocusNode = FocusNode();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _selectedProjectIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ViewModelProvider<ViewModelConsulterTaches>.withConsumer(
      onModelReady: (model) => model.fetchAllProjects(""),
      viewModel: ViewModelConsulterTaches(),
      builder: (context, model, child) => Scaffold(
        drawer: AppDrawer(),
        backgroundColor: Color.fromARGB(240, 248, 255, 255),
        appBar: AppBar(
          title: Text("Ressource Management"),
        ),
        body: Builder(builder: (BuildContext ctx) {
          return BusyOverlay(
            show: model.state == ViewState.Busy,
            isDisabled: model.state == ViewState.Busy ? true : false,
            child: Container(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Task Management",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  verticalSpaceMedium,
                  TextFormFieldWidget(
                    textEditingController: _ecSearchProject,
                    textAlign: TextAlign.start,
                    counterColor: Colors.blue,
                    labelText: "Search",
                    labelTextColor: Colors.blue,
                    textInputAction: TextInputAction.search,
                    fieldFocusNode: _searchFocusNode,
                    labelTextFontWeight: FontWeight.bold,
                    prefixIcon: Icons.search,
                    prefixColorIcon: Colors.blue,
                    inputBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                    ),
                    onEditingComplete: () =>
                        model.fetchAllProjects(_ecSearchProject.text),
                  ),
                  verticalSpaceSmall,
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextWidget(
                      text:
                          "Projects (" + model.projects.length.toString() + ")",
                    ),
                  ),
                  verticalSpaceTiny,
                  Container(
                    height: 100.0,
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: model.projects.length,
                      itemBuilder: (context, index) {
                        return HorizontalListProjectItem(
                          projectName: model.projects[index].title,
                          itemColor: _selectedProjectIndex == index
                              ? Color(0xFF417BFB)
                              : Color(0xFFF5F7FB),
                          itemTextColor: _selectedProjectIndex == index
                              ? Colors.white
                              : Colors.black,
                          onTap: () {
                            setState(() {
                              _selectedProjectIndex = index;
                            });
                            model.fetchProjectTasks(
                                model.projects[_selectedProjectIndex].id);
                          },
                        );
                      },
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () => model.navigateToKanbanBoard(
                        model.projects[_selectedProjectIndex]),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text("Kanban Board",
                              style: TextStyle(color: Colors.blue)),
                          Icon(
                            Icons.subdirectory_arrow_right,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Color(0xFFAFB4C6),
                    indicatorColor: Color(0xFF417BFB),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 4.0,
                    tabs: myTabs,
                  ),
                  [
                    Expanded(
                      child: Container(
                        child: new ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: model.toDoList == null
                              ? 0
                              : model.toDoList.length,
                          itemBuilder: (context, index) {
                            return TaskListViewItem(
                              onTap: () => model.navigateToUpdateView(
                                  model.toDoList[index],
                                  model.projects[_selectedProjectIndex]),
                              onLongPress: () => model.deleteTask(
                                  model.projects[_selectedProjectIndex],
                                  model.toDoList[index],
                                  ctx),
                              taskTitle: model.toDoList == null
                                  ? ""
                                  : model.toDoList[index].title,
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: new ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: model.doingList == null
                              ? 0
                              : model.doingList.length,
                          itemBuilder: (context, index) {
                            return TaskListViewItem(
                                onTap: () => model.navigateToUpdateView(
                                    model.doingList[index],
                                    model.projects[_selectedProjectIndex]),
                                onLongPress: () => model.deleteTask(
                                    model.projects[_selectedProjectIndex],
                                    model.doingList[index],
                                    ctx),
                                taskTitle: model.doingList == null
                                    ? ""
                                    : model.doingList[index].title);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: new ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: model.doneList == null
                              ? 0
                              : model.doneList.length,
                          itemBuilder: (context, index) {
                            return TaskListViewItem(
                                onTap: () => model.navigateToUpdateView(
                                    model.doneList[index],
                                    model.projects[_selectedProjectIndex]),
                                onLongPress: () => model.deleteTask(
                                    model.projects[_selectedProjectIndex],
                                    model.doneList[index],
                                    ctx),
                                taskTitle: model.doneList == null
                                    ? ""
                                    : model.doneList[index].title);
                          },
                        ),
                      ),
                    ),
                  ][_tabController.index],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _ecSearchProject.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }
}
