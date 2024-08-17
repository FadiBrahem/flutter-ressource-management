import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelAjouterTaches.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/ButtonWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/DropDownWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextFormFieldWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/horizontal_list_project_item.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/ressource_listview_item.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:intl/intl.dart';
import 'package:enum_to_string/enum_to_string.dart';

class AjouterTachesView extends StatefulWidget {
  @override
  _AjouterTachesViewState createState() => _AjouterTachesViewState();
}

class _AjouterTachesViewState extends State<AjouterTachesView> {
  //Form Fields
  final _formKey = GlobalKey<FormState>();
  TextEditingController _ecTaskTitle, _ecTaskdescription, _ecSearchProject;
  FocusNode _titleFocusNode, _descriptionFocusNode, _searchFocusNode;

  //Project Fields
  DateTime _dateStartTask, _dateEndTask;
  String _statusSelectedItem;
  int _selectedProjectIndex;
  String _selectedRessId;

  @override
  void initState() {
    super.initState();
    _ecSearchProject = TextEditingController();
    _ecTaskTitle = TextEditingController();
    _ecTaskdescription = TextEditingController();
    _searchFocusNode = FocusNode();
    _titleFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _dateStartTask =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _dateEndTask =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _selectedProjectIndex = 0;
    _statusSelectedItem = EnumToString.parse(TaskStatus.ToDo);
    _selectedRessId = "";
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ViewModelProvider<ViewModelAjouterTaches>.withConsumer(
      viewModel: ViewModelAjouterTaches(),
      onModelReady: (model) => model.fetchAllProjects(""),
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
            child: Form(
              key: _formKey,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                          //shrinkWrap: true,
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
                                  model.fetchAllRessourcesProject(
                                      model.projects[index]);
                                });
                              },
                            );
                          },
                        ),
                      ),
                      verticalSpaceSmall,
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextWidget(
                          text: "Title",
                        ),
                      ),
                      verticalSpaceSmall,
                      _buildTitle(
                          _ecTaskTitle, _titleFocusNode, _descriptionFocusNode),
                      verticalSpaceSmall,
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextWidget(
                          text: "Description",
                        ),
                      ),
                      verticalSpaceSmall,
                      _buildDescription(
                          _ecTaskdescription, _descriptionFocusNode),
                      verticalSpaceTiny,
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
                                              _showDateStartTimePicker(),
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
                      verticalSpaceTiny,
                      Row(
                        children: <Widget>[
                          TextWidget(
                            text: "Statuts:",
                          ),
                          horizentalSpace(50),
                          DropDownWidget(
                            itemsToBeSelected: _listDropDownStatuts(),
                            selectedItem: _statusSelectedItem,
                            onChanged: (String value) {
                              setState(() {
                                _statusSelectedItem = value;
                              });
                            },
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextWidget(text: "Affecter Ressources :"),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          height: screenHeight(context) / 5,
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
                      verticalSpaceSmall,
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ButtonWidget(
                          text: "Save",
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              ProjectTask newTask = ProjectTask(
                                  title: _ecTaskTitle.text,
                                  description: _ecTaskdescription.text,
                                  status: _statusSelectedItem,
                                  startDate: _dateStartTask,
                                  endDate: _dateEndTask,
                                  idResource: _selectedRessId);
                              model.addTask(
                                  newTask,
                                  model.projects[_selectedProjectIndex].id,
                                  ctx);
                              resetForm(_formKey, _ecTaskTitle,
                                  _ecTaskdescription, _selectedRessId);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
    _ecTaskTitle.dispose();
    _ecTaskdescription.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _searchFocusNode.dispose();
  }

  Widget _buildTitle(TextEditingController editingController,
      FocusNode actualFN, FocusNode nextFN) {
    return TextFormFieldWidget(
      textAlign: TextAlign.start,
      prefixIcon: Icons.title,
      textEditingController: editingController,
      inputBorder: new OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      textInputAction: TextInputAction.next,
      fieldFocusNode: actualFN,
      nextFocusNode: nextFN,
      validator: (String value) {
        if (value.isEmpty) {
          return "Title should not be empty";
        }
        return null;
      },
    );
  }

  Widget _buildDescription(
      TextEditingController editingController, FocusNode actualFN) {
    return TextFormFieldWidget(
      textAlign: TextAlign.start,
      prefixIcon: Icons.description,
      textEditingController: editingController,
      maxLines: 2,
      inputBorder: new OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      textInputAction: TextInputAction.next,
      fieldFocusNode: actualFN,
      validator: (String value) {
        if (value.isEmpty) {
          return "Description should not be empty";
        }
        return null;
      },
    );
  }

  _showDateStartTimePicker() async {
    _dateStartTask = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    setState(() {});
  }

  _showDateEndTimePicker() async {
    _dateEndTask = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    setState(() {});
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

void resetForm(GlobalKey<FormState> globalKey, TextEditingController titleEC,
    TextEditingController descriptionEC, String selectedRessource) {
  globalKey.currentState.reset();
  titleEC.clear();
  descriptionEC.clear();
  selectedRessource = "";
}
