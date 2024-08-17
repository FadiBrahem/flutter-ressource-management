import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelUpdateTask.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/DropDownWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextFormFieldWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/document_listview_item.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/document_listview_subItem.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/floatting_action_button_widget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/ressource_listview_item.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:intl/intl.dart';
import 'package:enum_to_string/enum_to_string.dart';

class TaskDetailsView extends StatefulWidget {
  final Map<String, dynamic> args;

  TaskDetailsView({@required this.args});

  @override
  _TaskDetailsViewState createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView>
    with SingleTickerProviderStateMixin {
  //Form Fields
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleEditingController;
  TextEditingController _descriptionEditingController;
  FocusNode _titleFN = new FocusNode();
  FocusNode _descriptionFN = new FocusNode();
  bool _titleEnabled, _descriptionEnabled;

  //Project Fields
  String _selectedStatus;
  DateTime _dateStartTask;
  DateTime _dateEndTask;
  Project _project;
  ProjectTask _projectTask;
  String _selectedRessId;

  //Tab Controller Fields
  final List<Widget> myTabs = [
    Tab(text: 'Manage Documents'),
    Tab(text: 'Assign Ressources'),
  ];
  TabController _tabController;

  //Document Fields
  List<TextEditingController> _notesEditingControllers;

  @override
  void initState() {
    super.initState();
    _project = widget.args["project"];
    _projectTask = widget.args["task"];
    _titleEditingController = TextEditingController(text: _projectTask.title);
    _descriptionEditingController =
        TextEditingController(text: _projectTask.description);
    _titleEnabled = false;
    _descriptionEnabled = false;
    _selectedStatus = _projectTask.status;
    _dateStartTask = _projectTask.startDate;
    _dateEndTask = _projectTask.endDate;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _notesEditingControllers = List();
    _selectedRessId = _projectTask.idResource;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ViewModelProvider<ViewModelUpdateTasks>.withConsumer(
      viewModel: ViewModelUpdateTasks(),
      onModelReady: (model) => model.fetchAllRessourcesProject(_project),
      builder: (context, model, child) => Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Ressource Management"),
          backgroundColor: Colors.blue,
        ),
        body: BusyOverlay(
          show: model.state == ViewState.Busy,
          isDisabled: model.state == ViewState.Busy ? true : false,
          child: Form(
            key: _formKey,
            child: Container(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextWidget(
                        text: "Title",
                      ),
                    ),
                    verticalSpaceSmall,
                    _buildTitle(),
                    verticalSpaceSmall,
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextWidget(
                        text: "Description",
                      ),
                    ),
                    verticalSpaceSmall,
                    _buildDescription(),
                    verticalSpaceSmall,
                    Row(
                      children: <Widget>[
                        Container(
                          width: screenWidth(context) / 2 - 20,
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextWidget(text: "Date Debut :"),
                              ),
                              verticalSpaceTiny,
                              Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      _dateStartTask != null
                                          ? new Text(
                                              new DateFormat('yyyy-MM-dd')
                                                  .format(_dateStartTask),
                                              style: new TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0,
                                              ),
                                            )
                                          : new SizedBox(
                                              width: 0.0,
                                              height: 0.0,
                                            ),
                                      IconButton(
                                        icon: new Icon(
                                          Icons.date_range,
                                          color: Colors.black,
                                        ),
                                        onPressed: () =>
                                            _showDateStartedTimePicker(),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          width: (screenWidth(context) / 2 - 20),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextWidget(text: "Date Fin :"),
                              ),
                              verticalSpaceTiny,
                              Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      _dateEndTask != null
                                          ? new Text(
                                              new DateFormat('yyyy-MM-dd')
                                                  .format(_dateEndTask),
                                              style: new TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0,
                                              ),
                                            )
                                          : new SizedBox(
                                              width: 0.0,
                                              height: 0.0,
                                            ),
                                      IconButton(
                                        icon: new Icon(
                                          Icons.date_range,
                                          color: Colors.black,
                                        ),
                                        onPressed: () =>
                                            _showDateEndTimePicker(),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    _buildStatus(),
                    verticalSpaceSmall,
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
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          height: screenHeight(context) / 3,
                          child: new ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return DocumentListViewItem(
                                titleFile: "Maquette add project",
                                fileNotesWidget: Container(
                                  height: screenHeight(context) / 6,
                                  child: Scrollbar(
                                    child: new ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: 8,
                                      itemBuilder: (ctx, indice) {
                                        _notesEditingControllers.add(
                                            TextEditingController(
                                                text: "note"));
                                        return DocumentListViewSubItem(
                                          textEditingController:
                                              _notesEditingControllers[indice],
                                          //delete doit etre faite avec dissmissible widget
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          height: screenHeight(context) / 3,
                          child: new ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: model.ressourcesInProject.length,
                            itemBuilder: (context, index) {
                              return RessourceListViewItem(
                                ressourceName: model
                                        .ressourcesInProject[index].getName +
                                    " " +
                                    model.ressourcesInProject[index].lastName,
                                ressourceRole:
                                    model.userAccessInProject[index].roleName,
                                urlImgRessource:
                                    "https://cdn.maikoapp.com/3d4b/4quqa/150.jpg",
                                isChecked: _selectedRessId ==
                                    model.ressourcesInProject[index].getId,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      _selectedRessId = model
                                          .ressourcesInProject[index].getId;
                                    } else {
                                      _selectedRessId = "";
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ][_tabController.index],
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Builder(builder: (BuildContext ctx) {
          return FloatingActionButtonWidget(
            onTapUpdateTask: () {
              _projectTask.startDate = _dateStartTask;
              _projectTask.endDate = _dateEndTask;
              _projectTask.idResource = _selectedRessId;
              model.updateProjectTask(_project, _projectTask, ctx);
            },
            onTapAddDocument: () => model.navigateToAddDocumentView(),
          );
        }),
      ),
    );
  }

  Widget _buildTitle() {
    return InkWell(
      onLongPress: () {
        setState(() {
          _titleEnabled = true;
          _titleFN.requestFocus();
        });
      },
      child: TextFormFieldWidget(
        textEditingController: _titleEditingController,
        isEnabled: _titleEnabled,
        prefixIcon: Icons.title,
        inputBorder: new OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.next,
        fieldFocusNode: _titleFN,
        nextFocusNode: _descriptionFN,
        onChanged: (value) {
          _projectTask.setTitle = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return "Title should not be empty";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDescription() {
    return InkWell(
      onLongPress: () {
        setState(() {
          _descriptionEnabled = true;
        });
      },
      child: TextFormFieldWidget(
        textEditingController: _descriptionEditingController,
        isEnabled: _descriptionEnabled,
        maxLines: 2,
        prefixIcon: Icons.description,
        textAlign: TextAlign.start,
        fieldFocusNode: _descriptionFN,
        textInputAction: TextInputAction.next,
        inputBorder: new OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        onChanged: (value) {
          _projectTask.setDescription = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return "Description should not be empty";
          }
          return null;
        },
      ),
    );
  }

  _showDateStartedTimePicker() async {
    _dateStartTask = await showDatePicker(
      context: context,
      initialDate: _dateStartTask,
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
    );
    setState(() {});
  }

  _showDateEndTimePicker() async {
    _dateEndTask = await showDatePicker(
      context: context,
      initialDate: _dateEndTask,
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
    setState(() {});
  }

  Widget _buildStatus() {
    return Row(
      children: <Widget>[
        horizontalSpaceSmall,
        TextWidget(
          text: "Statuts :",
        ),
        horizontalSpaceMedium,
        DropDownWidget(
            itemsToBeSelected: _listDropDownStatuts(),
            selectedItem: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
                _projectTask.setStatuts = value;
              });
            }),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    _titleFN.dispose();
    _descriptionFN.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }
}

List<String> _listDropDownStatuts() {
  List<String> itemsTobeSelected = [
    EnumToString.parse(TaskStatus.ToDo),
    EnumToString.parse(TaskStatus.InProgress),
    EnumToString.parse(TaskStatus.Done),
  ];
  return itemsTobeSelected;
}
