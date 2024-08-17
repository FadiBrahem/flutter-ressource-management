import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelReporting.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextFormFieldWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/horizontal_list_project_item.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/task_stats_card.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ReportingView extends StatefulWidget {
  final Widget child;

  ReportingView({Key key, this.child}) : super(key: key);

  _ReportingViewState createState() => _ReportingViewState();
}

class _ReportingViewState extends State<ReportingView>
    with SingleTickerProviderStateMixin {
  //Tab Controller Fields
  final List<Widget> myTabs = [
    Tab(
      child: Icon(Icons.home),
    ),
    Tab(
      icon: Icon(FontAwesomeIcons.chartPie),
    ),
    Tab(icon: Icon(FontAwesomeIcons.solidChartBar)),
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
    return ViewModelProvider<ViewModelReporting>.withConsumer(
      onModelReady: (model) => model.fetchAllProjects(""),
      viewModel: ViewModelReporting(),
      builder: (context, model, child) => Scaffold(
        //drawer: AppDrawer(),
        backgroundColor: Color.fromARGB(240, 248, 255, 255),

        body: BusyOverlay(
          show: model.state == ViewState.Busy,
          isDisabled: model.state == ViewState.Busy ? true : false,
          child: Container(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Column(
              children: <Widget>[
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
                  //General Tab (1st tab)
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: <Widget>[
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
                            text: "Projects (" +
                                model.projects.length.toString() +
                                ")",
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
                                  model.generalReportsByProject(
                                      model.projects[_selectedProjectIndex].id);
                                },
                              );
                            },
                          ),
                        ),
                        Divider(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Tasks stats"),
                        ),
                        verticalSpaceSmall,
                        Container(
                          height: screenHeight(context) / 2.5,
                          child: new ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              verticalSpaceSmall,
                              TaskStatsCard(
                                cardColor: Colors.amber,
                                loadingPercent: _percentTasks(
                                        model.totalTasks, model.totalTasks) /
                                    100,
                                percentTasks: _percentTasks(
                                            model.totalTasks, model.totalTasks)
                                        .toString() +
                                    "%",
                                title: "Total Tasks",
                                subtitle:
                                    model.totalTasksHours.toString() + " hours",
                              ),
                              horizontalSpaceSmall,
                              TaskStatsCard(
                                cardColor: Colors.blue,
                                percentTasks: _percentTasks(
                                            model.todayTasks, model.totalTasks)
                                        .toString() +
                                    "%",
                                loadingPercent: _percentTasks(
                                        model.todayTasks, model.totalTasks) /
                                    100,
                                title: 'Today Tasks',
                                subtitle:
                                    model.todayTasksHours.toString() + " hours",
                              ),
                              horizontalSpaceSmall,
                              TaskStatsCard(
                                cardColor: Colors.red,
                                loadingPercent: _percentTasks(
                                        model.lateTasks, model.totalTasks) /
                                    100,
                                percentTasks: _percentTasks(
                                            model.lateTasks, model.totalTasks)
                                        .toString() +
                                    "%",
                                title: 'Late Tasks',
                                subtitle:
                                    model.lateTasksHours.toString() + " hours",
                              ),
                              horizontalSpaceSmall,
                              TaskStatsCard(
                                cardColor: Colors.green,
                                loadingPercent: _percentTasks(
                                        model.completedTasks,
                                        model.totalTasks) /
                                    100,
                                percentTasks: _percentTasks(
                                            model.completedTasks,
                                            model.totalTasks)
                                        .toString() +
                                    "%",
                                title: 'Completed Tasks',
                                subtitle: model.completedTasksHours.toString() +
                                    " hours",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Pie Charts for Risks (2nd Tab)
                  Expanded(
                    child: charts.PieChart(model.risksPieChart,
                        animate: true,
                        animationDuration: Duration(seconds: 5),
                        behaviors: [
                          new charts.DatumLegend(
                            outsideJustification:
                                charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            desiredMaxRows: 2,
                            cellPadding:
                                new EdgeInsets.only(right: 4.0, bottom: 4.0),
                            entryTextStyle: charts.TextStyleSpec(
                                color:
                                    charts.MaterialPalette.purple.shadeDefault,
                                fontFamily: 'Georgia',
                                fontSize: 11),
                          )
                        ],
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 100,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.inside)
                            ])),
                  ),

                  //(3rd Tab)
                  Expanded(
                    child: charts.BarChart(
                      model.ressTasksProgress,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped,
                      behaviors: [new charts.SeriesLegend()],
                      animationDuration: Duration(seconds: 5),
                    ),
                  ),
                ][_tabController.index],
              ],
            ),
          ),
        ),
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
      if (_selectedProjectIndex == -1)
        setState(() {
          _tabController.index = 0;
          //afficher alert (you must select a project in 1st Tab)
        });
      else {
        setState(() {});
      }
    }
  }
}

int _percentTasks(
    List<ProjectTask> lstProjectTasks, List<ProjectTask> lstTotal) {
  if (lstProjectTasks == null) {
    return 0;
  } else if (lstProjectTasks.length == 0) {
    return 0;
  } else {
    return ((lstProjectTasks.length * 100) / lstTotal.length).round();
  }
}
